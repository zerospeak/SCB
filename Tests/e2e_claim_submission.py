import requests

def test_claim_submission():
    url = "http://localhost:5000/api/claims"
    claim = {
        "ProviderID": "P1",
        "MemberSSN": "123-45-6789",
        "PaidAmount": 1000.0,
        "IsFraud": None
    }
    response = requests.post(url, json=claim)
    assert response.status_code == 200
    assert "risk" in response.json()

if __name__ == "__main__":
    test_claim_submission()
    print("E2E claim submission test passed.")
