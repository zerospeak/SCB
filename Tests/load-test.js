import http from 'k6/http';
import { check } from 'k6';

export let options = {
    vus: 100,
    duration: '30s',
};

export default function () {
    const url = __ENV.API_URL || 'http://localhost:5000/api/claims';
    const payload = JSON.stringify({
        ProviderID: 'P123',
        MemberSSN: '123-45-6789',
        PaidAmount: 1000.00,
        IsFraud: null
    });
    const params = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${__ENV.API_KEY}`
        },
    };
    let res = http.post(url, payload, params);
    check(res, { 'status is 200': (r) => r.status === 200 });
}
