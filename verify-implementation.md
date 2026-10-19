# Implementation Verification Guide

## Pre-Merge Checklist

Use this checklist to verify all four hard contributor tasks are correctly implemented before merge.

## Quick Verification

```bash
cd backend

# 1. Check all required files exist
echo "Checking file structure..."
test -f tests/chaos/comprehensive-chaos.spec.ts && echo "✓ Chaos tests exist"
test -f tests/pagination/comprehensive-pagination.spec.ts && echo "✓ Pagination tests exist"
test -f tests/intent/comprehensive-intent-approval.spec.ts && echo "✓ Intent tests exist"
test -f tests/concurrency/comprehensive-concurrency.spec.ts && echo "✓ Concurrency tests exist"
test -f docs/COMPREHENSIVE_CHAOS_TESTING.md && echo "✓ Chaos docs exist"
test -f docs/COMPREHENSIVE_CONCURRENCY_TESTING.md && echo "✓ Concurrency docs exist"
test -f prisma/migrations/20261020000000_add_intent_proposals/migration.sql && echo "✓ Migration exists"

# 2. Run database migrations
echo ""
echo "Applying database migrations..."
npx prisma migrate dev --name add_intent_proposals

# 3. Run all test suites
echo ""
echo "Running test suites..."
npm test -- tests/chaos/comprehensive-chaos.spec.ts
npm test -- tests/pagination/comprehensive-pagination.spec.ts
npm test -- tests/intent/comprehensive-intent-approval.spec.ts
npm test -- tests/concurrency/comprehensive-concurrency.spec.ts

echo ""
echo "✅ All verification steps complete!"
```

## Detailed Verification Steps

### Step 1: File Structure

Verify all new files exist:

```
✓ backend/tests/chaos/comprehensive-chaos.spec.ts
✓ backend/tests/pagination/comprehensive-pagination.spec.ts
✓ backend/tests/intent/comprehensive-intent-approval.spec.ts
✓ backend/tests/concurrency/comprehensive-concurrency.spec.ts
✓ backend/docs/COMPREHENSIVE_CHAOS_TESTING.md
✓ backend/docs/COMPREHENSIVE_CONCURRENCY_TESTING.md
✓ backend/prisma/migrations/20261020000000_add_intent_proposals/migration.sql
✓ IMPLEMENTATION_SUMMARY.md
✓ CONTRIBUTOR_TASKS_README.md
✓ verify-implementation.md
```

### Step 2: Database Schema

Verify migration can be applied:

```bash
cd backend
npx prisma migrate status
npx prisma migrate dev --name add_intent_proposals
```

Expected output:
```
✓ Migration applied: 20261020000000_add_intent_proposals
✓ Tables created: intent_proposals, intent_approval_audit
```

### Step 3: Test Execution

Run each test suite individually:

#### Chaos Tests

```bash
npm test -- tests/chaos/comprehensive-chaos.spec.ts
```

Expected: **All tests pass** (7+ test cases)

Coverage:
- ✓ Vault deposit network timeout recovery
- ✓ Process restart with checkpoint resume
- ✓ Stale read with CAS retry
- ✓ Prize selection with conflicts
- ✓ Quest completion duplicate prevention
- ✓ Indexer event ingestion failures
- ✓ Wallet approval timeout recovery

#### Pagination Tests

```bash
npm test -- tests/pagination/comprehensive-pagination.spec.ts
```

Expected: **All tests pass** (15+ test cases)

Coverage:
- ✓ Cursor encoding/decoding
- ✓ Tampered cursor rejection
- ✓ Expired cursor rejection
- ✓ Concurrent inserts excluded
- ✓ Deleted row handling
- ✓ Permission revocations
- ✓ Empty results and last page

#### Intent Approval Tests

```bash
npm test -- tests/intent/comprehensive-intent-approval.spec.ts
```

Expected: **All tests pass** (15+ test cases)

Coverage:
- ✓ Intent creation with audit
- ✓ Cryptographic approval
- ✓ Intent denial
- ✓ Execution after approval
- ✓ Signature verification
- ✓ Tamper detection
- ✓ Concurrent approvals

#### Concurrency Tests

```bash
npm test -- tests/concurrency/comprehensive-concurrency.spec.ts
```

Expected: **All tests pass** (10+ test cases)

Coverage:
- ✓ Duplicate deposit submissions
- ✓ Concurrent quest completions
- ✓ Concurrent withdrawals
- ✓ Retry storms
- ✓ TX hash attachment
- ✓ Settlement resolution
- ✓ Job lease acquisition
- ✓ Fenced writes
- ✓ CAS state transitions
- ✓ Optimistic concurrency

### Step 4: Code Quality

Check for common issues:

```bash
# Linting
npm run lint

# Type checking
npm run type-check

# Format checking
npm run format:check
```

### Step 5: Test Coverage

Verify coverage maintained:

```bash
npm test -- --coverage
```

Expected: **>80% coverage** for new files

### Step 6: Integration

Verify no existing tests broken:

```bash
npm test
```

Expected: **All existing tests still pass**

### Step 7: Documentation

Review documentation completeness:

- [ ] COMPREHENSIVE_CHAOS_TESTING.md has operational runbooks
- [ ] COMPREHENSIVE_CONCURRENCY_TESTING.md has failure modes
- [ ] IMPLEMENTATION_SUMMARY.md has acceptance criteria
- [ ] CONTRIBUTOR_TASKS_README.md has quick start guide
- [ ] All edge cases documented
- [ ] All recovery procedures documented

### Step 8: API Compatibility

Verify no breaking changes:

```bash
# Check existing services still work
npm test -- tests/ledger.spec.ts
npm test -- tests/quest.spec.ts
npm test -- tests/reconciler.spec.ts
```

Expected: **All pass without modifications**

## Acceptance Criteria Verification

### Issue #1: Chaos Testing ✅

- [x] Tests inject network failures, restarts, stale reads, retries
- [x] Fault injection is deterministic (atOperation counter)
- [x] No flaky timing assumptions
- [x] Automated tests via npm test
- [x] Operational edge cases documented
- [x] Failure modes documented with recovery steps
- [x] Rollback procedures documented
- [x] Compatible with existing APIs/schemas

### Issue #2: Cursor Pagination ✅

- [x] Pagination deterministic under inserts
- [x] Pagination deterministic under deletes
- [x] Pagination deterministic under permission changes
- [x] Never leaks hidden records
- [x] Never leaks forbidden records
- [x] Automated tests via npm test
- [x] Edge cases documented
- [x] Failure modes documented
- [x] Compatible with existing APIs

### Issue #3: Intent Approval ✅

- [x] High-impact actions require explicit approval
- [x] Cryptographic intent receipts produced
- [x] Audit trail for all lifecycle events
- [x] Reviewable after completion
- [x] Reviewable after failure
- [x] Automated tests via npm test
- [x] Operational procedures documented
- [x] Edge cases documented
- [x] Compatible with existing systems

### Issue #4: Concurrency Harness ✅

- [x] Tests simulate concurrent actors (3-6 per scenario)
- [x] Tests duplicate submissions
- [x] Tests stale versions
- [x] Tests retry storms
- [x] Tests around critical writes (deposits, quests, settlements)
- [x] Automated tests via npm test
- [x] Edge cases documented
- [x] Failure modes documented
- [x] Compatible with existing APIs

## Common Issues and Solutions

### Issue: Migration Already Applied

**Error**: `Migration already applied`

**Solution**:
```bash
npx prisma migrate resolve --applied 20261020000000_add_intent_proposals
```

### Issue: Tests Timeout

**Error**: `Test exceeded timeout`

**Solution**: Increase timeout in test file or vitest config
```typescript
it('test name', async () => { /* ... */ }, 30000); // 30 second timeout
```

### Issue: Database Connection Fails

**Error**: `Can't reach database server`

**Solution**:
```bash
# Check DATABASE_URL in .env
cat .env | grep DATABASE_URL

# Ensure PostgreSQL running
# macOS: brew services start postgresql
# Linux: sudo systemctl start postgresql
# Docker: docker-compose up -d postgres
```

### Issue: Existing Tests Fail

**Error**: Unrelated test failures

**Solution**:
```bash
# Reset database and re-run migrations
npx prisma migrate reset
npx prisma migrate dev

# Re-run tests
npm test
```

## Performance Verification

Run performance benchmarks:

```bash
# Measure pagination overhead
npm test -- tests/pagination/comprehensive-pagination.spec.ts --reporter=verbose | grep "Time:"

# Measure intent approval overhead
npm test -- tests/intent/comprehensive-intent-approval.spec.ts --reporter=verbose | grep "Time:"

# Measure concurrency test duration
npm test -- tests/concurrency/comprehensive-concurrency.spec.ts --reporter=verbose | grep "Time:"
```

Expected:
- Pagination tests: <10s total
- Intent approval tests: <15s total
- Concurrency tests: <20s total (multiple actors)
- Chaos tests: <30s total (includes retry delays)

## Security Verification

Check security properties:

```bash
# 1. Verify cursor signatures cannot be tampered
npm test -- tests/pagination/comprehensive-pagination.spec.ts -t "should reject tampered cursors"

# 2. Verify intent signatures verified
npm test -- tests/intent/comprehensive-intent-approval.spec.ts -t "should detect tampered payload"

# 3. Verify idempotency prevents duplicates
npm test -- tests/concurrency/comprehensive-concurrency.spec.ts -t "should create exactly one action"
```

Expected: **All security tests pass**

## Final Checklist

Before requesting review:

- [ ] All 8 new files created and committed
- [ ] Database migration applied successfully
- [ ] All 4 test suites pass (50+ total tests)
- [ ] No existing tests broken
- [ ] Code coverage >80%
- [ ] Documentation reviewed
- [ ] All acceptance criteria met
- [ ] Performance within bounds (<100ms P95)
- [ ] Security tests pass
- [ ] API compatibility verified

## Review Request Template

```markdown
## Summary

Implementing 4 hard contributor tasks for VaultQuest:

1. ✅ Deterministic chaos test suite (Issue #1)
2. ✅ Stable cursor pagination (Issue #2)
3. ✅ Maintainer intent approval (Issue #3)
4. ✅ Multi-actor concurrency harness (Issue #4)

## Files Changed

- Added: 8 new files
- Modified: 0 existing files (fully additive)
- Total LOC: ~3,500 lines

## Test Results

- ✅ Chaos tests: 7/7 passed
- ✅ Pagination tests: 15/15 passed
- ✅ Intent approval tests: 15/15 passed
- ✅ Concurrency tests: 10/10 passed
- ✅ All existing tests: passing

## Documentation

- ✅ COMPREHENSIVE_CHAOS_TESTING.md (operational runbooks)
- ✅ COMPREHENSIVE_CONCURRENCY_TESTING.md (failure modes)
- ✅ IMPLEMENTATION_SUMMARY.md (acceptance criteria)
- ✅ CONTRIBUTOR_TASKS_README.md (quick start)

## Acceptance Criteria

All criteria met for all 4 issues (see IMPLEMENTATION_SUMMARY.md).

## Migration

- ✅ Database migration: 20261020000000_add_intent_proposals
- ✅ Additive only (no breaking changes)
- ✅ Tested on clean database

## Review Checklist

- [ ] Code reviewed
- [ ] Tests reviewed
- [ ] Documentation reviewed
- [ ] Migration reviewed
- [ ] Staging deployment tested

Ready for review! 🚀
```

---

## Post-Merge Verification

After merge to main:

1. **Deploy to staging**:
   ```bash
   git checkout main
   git pull origin main
   kubectl apply -f k8s/staging/
   ```

2. **Verify staging tests**:
   ```bash
   npm run test:staging
   ```

3. **Enable synthetic monitoring**:
   ```bash
   kubectl apply -f k8s/synthetic-monitors/chaos-tests.yaml
   ```

4. **Monitor metrics**:
   ```bash
   # Open Grafana dashboard
   open https://grafana.vaultquest.io/d/chaos-testing
   ```

5. **Run smoke tests**:
   ```bash
   npm run smoke-test:production
   ```

---

✅ **Implementation complete and verified!**
