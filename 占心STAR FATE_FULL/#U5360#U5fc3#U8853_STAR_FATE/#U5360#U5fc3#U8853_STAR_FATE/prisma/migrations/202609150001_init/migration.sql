-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('user', 'admin');
CREATE TYPE "ProductStatus" AS ENUM ('active', 'inactive');
CREATE TYPE "OrderStatus" AS ENUM ('pending', 'paid', 'failed', 'cancelled', 'refunded');

-- CreateTable
CREATE TABLE "users" ("id" TEXT NOT NULL, "email" TEXT NOT NULL, "password_hash" TEXT, "name" TEXT, "google_id" TEXT, "role" "UserRole" NOT NULL DEFAULT 'user', "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updated_at" TIMESTAMP(3) NOT NULL, CONSTRAINT "users_pkey" PRIMARY KEY ("id"));
CREATE TABLE "sessions" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "token_hash" TEXT NOT NULL, "expires_at" TIMESTAMP(3) NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "sessions_pkey" PRIMARY KEY ("id"));
CREATE TABLE "fortune_results" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "type" TEXT NOT NULL, "question" TEXT, "birth_date" DATE NOT NULL, "birth_time" TEXT, "gender" TEXT, "blood_type" TEXT, "zodiac" TEXT, "result_data" JSONB NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "fortune_results_pkey" PRIMARY KEY ("id"));
CREATE TABLE "couple_fortunes" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "person_a_data" JSONB NOT NULL, "person_b_data" JSONB NOT NULL, "result_data" JSONB NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "couple_fortunes_pkey" PRIMARY KEY ("id"));
CREATE TABLE "daily_fortunes" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "fortune_date" DATE NOT NULL, "birth_date" DATE NOT NULL, "result_data" JSONB NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "daily_fortunes_pkey" PRIMARY KEY ("id"));
CREATE TABLE "products" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "slug" TEXT NOT NULL, "description" TEXT, "price" INTEGER NOT NULL, "currency" TEXT NOT NULL DEFAULT 'TWD', "status" "ProductStatus" NOT NULL DEFAULT 'active', "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updated_at" TIMESTAMP(3) NOT NULL, CONSTRAINT "products_pkey" PRIMARY KEY ("id"));
CREATE TABLE "orders" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "product_id" TEXT NOT NULL, "amount" INTEGER NOT NULL, "currency" TEXT NOT NULL DEFAULT 'TWD', "status" "OrderStatus" NOT NULL DEFAULT 'pending', "payment_provider" TEXT, "payment_reference" TEXT, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updated_at" TIMESTAMP(3) NOT NULL, CONSTRAINT "orders_pkey" PRIMARY KEY ("id"));
CREATE TABLE "paid_results" ("id" TEXT NOT NULL, "order_id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "product_id" TEXT NOT NULL, "result_data" JSONB NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "paid_results_pkey" PRIMARY KEY ("id"));
CREATE TABLE "favorites" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "fortune_id" TEXT NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "favorites_pkey" PRIMARY KEY ("id"));
CREATE TABLE "shares" ("id" TEXT NOT NULL, "user_id" TEXT NOT NULL, "fortune_id" TEXT NOT NULL, "share_token" TEXT NOT NULL, "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "expires_at" TIMESTAMP(3), CONSTRAINT "shares_pkey" PRIMARY KEY ("id"));

CREATE UNIQUE INDEX "users_email_key" ON "users"("email");
CREATE UNIQUE INDEX "users_google_id_key" ON "users"("google_id");
CREATE UNIQUE INDEX "sessions_token_hash_key" ON "sessions"("token_hash");
CREATE UNIQUE INDEX "daily_fortunes_user_id_fortune_date_birth_date_key" ON "daily_fortunes"("user_id", "fortune_date", "birth_date");
CREATE UNIQUE INDEX "products_slug_key" ON "products"("slug");
CREATE UNIQUE INDEX "favorites_user_id_fortune_id_key" ON "favorites"("user_id", "fortune_id");
CREATE UNIQUE INDEX "shares_share_token_key" ON "shares"("share_token");
CREATE INDEX "sessions_user_id_idx" ON "sessions"("user_id");
CREATE INDEX "sessions_expires_at_idx" ON "sessions"("expires_at");
CREATE INDEX "fortune_results_user_id_created_at_idx" ON "fortune_results"("user_id", "created_at");
CREATE INDEX "couple_fortunes_user_id_created_at_idx" ON "couple_fortunes"("user_id", "created_at");
CREATE INDEX "daily_fortunes_user_id_fortune_date_idx" ON "daily_fortunes"("user_id", "fortune_date");
CREATE INDEX "orders_user_id_created_at_idx" ON "orders"("user_id", "created_at");
CREATE INDEX "orders_status_idx" ON "orders"("status");
CREATE INDEX "paid_results_user_id_created_at_idx" ON "paid_results"("user_id", "created_at");
CREATE INDEX "paid_results_order_id_idx" ON "paid_results"("order_id");
CREATE INDEX "favorites_user_id_created_at_idx" ON "favorites"("user_id", "created_at");
CREATE INDEX "shares_user_id_created_at_idx" ON "shares"("user_id", "created_at");
CREATE INDEX "shares_expires_at_idx" ON "shares"("expires_at");

ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "fortune_results" ADD CONSTRAINT "fortune_results_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "couple_fortunes" ADD CONSTRAINT "couple_fortunes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "daily_fortunes" ADD CONSTRAINT "daily_fortunes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "orders" ADD CONSTRAINT "orders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "orders" ADD CONSTRAINT "orders_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "paid_results" ADD CONSTRAINT "paid_results_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "paid_results" ADD CONSTRAINT "paid_results_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "paid_results" ADD CONSTRAINT "paid_results_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "favorites" ADD CONSTRAINT "favorites_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "favorites" ADD CONSTRAINT "favorites_fortune_id_fkey" FOREIGN KEY ("fortune_id") REFERENCES "fortune_results"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "shares" ADD CONSTRAINT "shares_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "shares" ADD CONSTRAINT "shares_fortune_id_fkey" FOREIGN KEY ("fortune_id") REFERENCES "fortune_results"("id") ON DELETE CASCADE ON UPDATE CASCADE;
