-- DROP ALL TABLES (in the right order to avoid FK issues)
DROP TABLE IF EXISTS
    chats,
    quiz,
    users,
    doctors,
    patients,
    addresses,
    patient_subscriptions,
    doctor_subscriptions
CASCADE;
