package digitaltrust;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

final class FraudAnalyzer {

    private static final Pattern MONEY_PATTERN = Pattern.compile(
        "(rs\\.?|inr|rupees?|₹)\\s*[0-9][0-9,]*(\\.[0-9]+)?|[0-9][0-9,]*(\\.[0-9]+)?\\s*(rs\\.?|inr|rupees?)",
        Pattern.CASE_INSENSITIVE);
    private static final Pattern URL_PATTERN = Pattern.compile(
        "(https?://\\S+|www\\.\\S+|\\b[a-z0-9.-]+\\.(com|net|org|in|info|xyz|top|site|online)\\S*)",
        Pattern.CASE_INSENSITIVE);
    private static final Set<String> SHORTENERS = new HashSet<>(Arrays.asList(
        "bit.ly", "tinyurl.com", "t.co", "goo.gl", "cutt.ly", "is.gd", "rebrand.ly"));

    private FraudAnalyzer() {
    }

    static FraudResult analyze(String input) {
        return analyze(input, Collections.<String, Integer>emptyMap());
    }

    static FraudResult analyze(String input, Map<String, Integer> blockedDomains) {
        String raw = TextUtil.clean(input).toLowerCase(Locale.ROOT);
        if (raw.isEmpty()) {
            return new FraudResult(0, "NO_INPUT", 100);
        }

        String clean = raw.replaceAll("[^a-z0-9₹.]+", " ");
        int risk = 0;
        int positive = 0;
        int redFlags = 0;

        redFlags += addIfContains(clean, "lottery", 25);
        redFlags += addIfContains(clean, "winner", 25);
        redFlags += addIfContains(clean, "jackpot", 25);
        redFlags += addIfContains(clean, "prize", 20);
        redFlags += addIfContains(clean, "congratulations", 15);
        redFlags += addIfContains(clean, "selected", 10);
        redFlags += addIfContains(clean, "lucky", 10);

        redFlags += addIfContains(clean, "claim now", 25);
        redFlags += addIfContains(clean, "act now", 20);
        redFlags += addIfContains(clean, "limited time", 20);
        redFlags += addIfContains(clean, "urgent", 20);
        redFlags += addIfContains(clean, "immediately", 15);
        redFlags += addIfContains(clean, "expire", 15);

        redFlags += addIfContains(clean, "otp", 25);
        redFlags += addIfContains(clean, "cvv", 30);
        redFlags += addIfContains(clean, "pin", 20);
        redFlags += addIfContains(clean, "password", 25);
        redFlags += addIfContains(clean, "account number", 25);
        redFlags += addIfContains(clean, "aadhaar", 15);
        redFlags += addIfContains(clean, "pan card", 15);

        redFlags += addIfContains(clean, "processing fee", 25);
        redFlags += addIfContains(clean, "registration fee", 25);
        redFlags += addIfContains(clean, "advance", 15);
        redFlags += addIfContains(clean, "deposit", 15);
        redFlags += addIfContains(clean, "upi", 10);
        redFlags += addIfContains(clean, "paytm", 10);
        redFlags += addIfContains(clean, "wallet", 10);

        risk += redFlags;

        if (containsAny(clean, "free money", "free cash", "free reward")) {
            risk += 20;
        }
        if (containsAny(clean, "click here", "open link", "verify account", "verify bank")) {
            risk += 20;
        }
        if (containsAny(clean, "pay fee", "pay a fee", "transfer money")) {
            risk += 20;
        }
        if (MONEY_PATTERN.matcher(raw).find() && containsAny(clean, "won", "claim", "prize", "lottery", "fee")) {
            risk += 15;
        }

        UrlSignal urlSignal = scoreUrls(raw, blockedDomains);
        risk += urlSignal.risk;
        positive += urlSignal.positive;

        int triggerCount = countTriggers(clean);
        if (triggerCount >= 3) {
            risk += 15;
        }
        if (triggerCount >= 5) {
            risk += 20;
        }

        int trustScore = clamp(100 - risk + positive, 0, 100);
        String label;
        if (urlSignal.blockedDomain != null) {
            label = "FRAUD";
        } else if (trustScore >= 75) {
            label = "SAFE";
        } else if (trustScore >= 50) {
            label = "SUSPICIOUS";
        } else {
            label = "FRAUD";
        }

        FraudResult result = new FraudResult(trustScore, label, risk);
        if (urlSignal.blockedDomain != null) {
            result.setBlockedDomain(urlSignal.blockedDomain, urlSignal.blockedPenalty);
        }
        return result;
    }

    static int fraudScore(String input) {
        return 100 - analyze(input).getTrustScore();
    }

    private static int addIfContains(String clean, String keyword, int points) {
        return clean.contains(keyword) ? points : 0;
    }

    private static boolean containsAny(String clean, String... terms) {
        for (String term : terms) {
            if (clean.contains(term)) {
                return true;
            }
        }
        return false;
    }

    private static int countTriggers(String clean) {
        int count = 0;
        String[] triggers = {
            "free", "won", "winner", "lottery", "prize", "urgent", "click",
            "verify", "pay", "fee", "claim", "otp", "cvv", "password"
        };
        for (String trigger : triggers) {
            if (clean.contains(trigger)) {
                count++;
            }
        }
        return count;
    }

    private static UrlSignal scoreUrls(String raw, Map<String, Integer> blockedDomains) {
        Matcher matcher = URL_PATTERN.matcher(raw);
        int risk = 0;
        int positive = 0;
        String blockedHit = null;
        int blockedHitPenalty = 0;

        while (matcher.find()) {
            String host = extractHost(matcher.group(1));
            if (host.isEmpty()) {
                risk += 15;
                continue;
            }

            if (blockedDomains != null && blockedDomains.containsKey(host)) {
                int penalty = blockedDomains.get(host);
                risk += penalty;
                if (blockedHit == null) {
                    blockedHit = host;
                    blockedHitPenalty = penalty;
                }
                continue;
            }

            if (host.endsWith(".gov.in") || host.endsWith(".nic.in")) {
                positive += 25;
            } else if (host.endsWith(".edu.in") || host.endsWith(".ac.in")) {
                positive += 8;
            } else {
                risk += 35;
            }

            if (SHORTENERS.contains(host)) {
                risk += 25;
            }
            if (host.contains("-") || host.matches(".*\\d.*")) {
                risk += 8;
            }
        }

        return new UrlSignal(risk, positive, blockedHit, blockedHitPenalty);
    }

    private static String extractHost(String value) {
        String candidate = value;
        if (!candidate.startsWith("http://") && !candidate.startsWith("https://")) {
            candidate = "https://" + candidate;
        }
        try {
            URI uri = new URI(candidate);
            String host = uri.getHost();
            if (host == null) {
                return "";
            }
            host = host.toLowerCase(Locale.ROOT);
            return host.startsWith("www.") ? host.substring(4) : host;
        } catch (URISyntaxException e) {
            return "";
        }
    }

    private static int clamp(int value, int min, int max) {
        if (value < min) {
            return min;
        }
        if (value > max) {
            return max;
        }
        return value;
    }

    private static final class UrlSignal {
        private final int risk;
        private final int positive;
        private final String blockedDomain;
        private final int blockedPenalty;

        private UrlSignal(int risk, int positive, String blockedDomain, int blockedPenalty) {
            this.risk = risk;
            this.positive = positive;
            this.blockedDomain = blockedDomain;
            this.blockedPenalty = blockedPenalty;
        }
    }
}
