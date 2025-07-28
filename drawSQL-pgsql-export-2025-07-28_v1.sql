CREATE TABLE "users"(
    "id" UUID NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "birthday" DATE NOT NULL,
    "email" TEXT NOT NULL,
    "psswd_hash" TEXT NOT NULL,
    "patient_profile" UUID NULL,
    "doctor_profile" UUID NULL,
    "date_creation" DATE NOT NULL
);
CREATE INDEX "users_email_id_index" ON
    "users"("email", "id");
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_email_unique" UNIQUE("email");
CREATE TABLE "patients"(
    "id" UUID NOT NULL,
    "alergies" JSON NOT NULL,
    "goal" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "address" UUID NOT NULL,
    "gender" SMALLINT NOT NULL,
    "weight" SMALLINT NOT NULL,
    "height" SMALLINT NOT NULL,
    "subscription" UUID NOT NULL
);
CREATE INDEX "patients_id_index" ON
    "patients"("id");
ALTER TABLE
    "patients" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "patients"."gender" IS '0 = male
1 = female';
COMMENT
ON COLUMN
    "patients"."weight" IS 'in KG (if frontend = lbs convert)';
COMMENT
ON COLUMN
    "patients"."height" IS 'in cm';
CREATE TABLE "doctors"(
    "id" UUID NOT NULL,
    "specialization" TEXT NOT NULL,
    "address" UUID NOT NULL,
    "phone_number" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "subscription" UUID NOT NULL
);
CREATE INDEX "doctors_id_index" ON
    "doctors"("id");
ALTER TABLE
    "doctors" ADD PRIMARY KEY("id");
CREATE TABLE "chats"(
    "id" UUID NOT NULL,
    "author" UUID NOT NULL,
    "content" jsonb NOT NULL,
    "date_updated" DATE NOT NULL
);
CREATE INDEX "chats_author_index" ON
    "chats"("author");
ALTER TABLE
    "chats" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "chats"."date_updated" IS 'date when the chat was created/last updated';
CREATE TABLE "quiz"(
    "id" UUID NOT NULL,
    "author" BIGINT NOT NULL,
    "content" jsonb NOT NULL,
    "date_taken" DATE NOT NULL
);
CREATE INDEX "quiz_author_index" ON
    "quiz"("author");
ALTER TABLE
    "quiz" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "quiz"."content" IS 'contains all the following json data:
medication currently taken
symptoms
history of diseases';
COMMENT
ON COLUMN
    "quiz"."date_taken" IS 'date when the quiz was taken';
CREATE TABLE "addresses"(
    "resident" UUID NOT NULL,
    "country" TEXT NOT NULL,
    "postcode" INTEGER NOT NULL,
    "city" TEXT NOT NULL,
    "address_line" TEXT NOT NULL
);
ALTER TABLE
    "addresses" ADD PRIMARY KEY("resident");
CREATE TABLE "patient_subscriptions"(
    "id" UUID NOT NULL,
    "tier" VARCHAR(255) CHECK
        ("tier" IN('Basic', 'Plus', 'Premium')) NOT NULL,
        "date_start" DATE NOT NULL,
        "date_end" DATE NULL,
        "status" VARCHAR(255)
    CHECK
        (
            "status" IN('paid', 'error', 'paused')
        ) NOT NULL
);
ALTER TABLE
    "patient_subscriptions" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "patient_subscriptions"."tier" IS '$27.90 (Basic), $33.90 (Plus), $39.90 (Premium)';
COMMENT
ON COLUMN
    "patient_subscriptions"."date_end" IS 'if subscribed for a year, then defined, if no date provided, then can keep using it :)';
COMMENT
ON COLUMN
    "patient_subscriptions"."status" IS 'paid = can use
error = cannot use
paused = cannot use (but not charged by stripe)';
CREATE TABLE "doctor_subscriptions"(
    "id" UUID NOT NULL,
    "tier" VARCHAR(255) CHECK
        ("tier" IN('solo', 'team', 'clinic')) NOT NULL,
        "date_start" DATE NOT NULL,
        "date_end" DATE NULL,
        "status" VARCHAR(255)
    CHECK
        (
            "status" IN('paid', 'error', 'paused')
        ) NOT NULL
);
ALTER TABLE
    "doctor_subscriptions" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "doctor_subscriptions"."tier" IS 'doctor subscription. can be null because most patient are
$219/mo → Solo
$389/mo → Team (up to 5 staff)
$650/mo → Clinic (15+ users, bulk upload, data export)';
COMMENT
ON COLUMN
    "doctor_subscriptions"."status" IS 'paid = can use
error = cannot use
paused = cannot use (but not charged by stripe)';
ALTER TABLE
    "users" ADD CONSTRAINT "users_patient_profile_foreign" FOREIGN KEY("patient_profile") REFERENCES "patients"("id");
ALTER TABLE
    "doctors" ADD CONSTRAINT "doctors_subscription_foreign" FOREIGN KEY("subscription") REFERENCES "doctor_subscriptions"("id");
ALTER TABLE
    "doctors" ADD CONSTRAINT "doctors_address_foreign" FOREIGN KEY("address") REFERENCES "addresses"("resident");
ALTER TABLE
    "chats" ADD CONSTRAINT "chats_author_foreign" FOREIGN KEY("author") REFERENCES "patients"("id");
ALTER TABLE
    "quiz" ADD CONSTRAINT "quiz_id_foreign" FOREIGN KEY("id") REFERENCES "patients"("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_doctor_profile_foreign" FOREIGN KEY("doctor_profile") REFERENCES "doctors"("id");
ALTER TABLE
    "patients" ADD CONSTRAINT "patients_subscription_foreign" FOREIGN KEY("subscription") REFERENCES "patient_subscriptions"("id");
ALTER TABLE
    "patients" ADD CONSTRAINT "patients_address_foreign" FOREIGN KEY("address") REFERENCES "addresses"("resident");
