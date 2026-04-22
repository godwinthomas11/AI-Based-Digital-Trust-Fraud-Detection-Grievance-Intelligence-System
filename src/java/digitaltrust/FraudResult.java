package digitaltrust;

final class FraudResult {

    private final int trustScore;
    private final String label;
    private final int riskPoints;
    private String blockedDomain;
    private int blockedPenalty;

    FraudResult(int trustScore, String label, int riskPoints) {
        this.trustScore = trustScore;
        this.label = label;
        this.riskPoints = riskPoints;
    }

    int getTrustScore() {
        return trustScore;
    }

    String getLabel() {
        return label;
    }

    int getRiskPoints() {
        return riskPoints;
    }

    boolean isSafe() {
        return trustScore >= 75;
    }

    String getBlockedDomain() {
        return blockedDomain;
    }

    int getBlockedPenalty() {
        return blockedPenalty;
    }

    void setBlockedDomain(String blockedDomain, int penalty) {
        this.blockedDomain = blockedDomain;
        this.blockedPenalty = penalty;
    }
}
