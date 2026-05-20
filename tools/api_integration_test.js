const base = 'https://kariyermimari.tech';

async function post(path, body) {
    const res = await fetch(base + path, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    });
    const text = await res.text();
    let data = null;
    try { data = JSON.parse(text); } catch (e) { data = { raw: text }; }
    return { status: res.status, data };
}

(async () => {
    try {
        console.log('START -> /api/start-experiment');
        const start = await post('/api/start-experiment', { student_name: 'CI_Test', school: 'CI_U', department: 'Bilgisayar', current_goal: 'Backend' });
        console.log(start);
        if (start.status < 200 || start.status >= 300) process.exit(2);

        const participantId = start.data.participantId || start.data.participant_id;
        if (!participantId) {
            console.error('participantId yok');
            process.exit(3);
        }

        const testAnswers = [
            { test: 'RIASEC', id: 'r1', type: 'R', answer: true },
            { test: 'RIASEC', id: 'r2', type: 'I', answer: false },
            { test: 'OCEAN', id: 'o1', type: 'O', answer: true },
        ];

        console.log('\nSUBMIT -> /api/submit-test');
        const submit = await post('/api/submit-test', { participantId, testAnswers });
        console.log(submit);
        if (submit.status < 200 || submit.status >= 300) process.exit(4);

        console.log('\nUNLOCK -> /api/unlock-ai-report');
        const unlock = await post('/api/unlock-ai-report', { participantId });
        console.log(unlock);
        if (unlock.status < 200 || unlock.status >= 300) process.exit(5);

        console.log('\nAll API calls succeeded.');
        process.exit(0);
    } catch (err) {
        console.error('Hata:', err);
        process.exit(10);
    }
})();
