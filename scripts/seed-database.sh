#!/bin/bash

# Database Seed Script for Whalink
# =================================

set -e

echo "🌱 Seeding database..."

cd backend

# Use the runWithProvider.js to run with correct schema
node runWithProvider.js "npx tsx prisma/seed.ts"

echo "✅ Database seeded successfully!"
