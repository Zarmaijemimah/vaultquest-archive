#!/bin/bash
#
# Comprehensive test runner for all four hard contributor issues.
# Runs chaos, pagination, intent approval, and concurrency test suites.
#

set -e

echo "=================================="
echo "VaultQuest Comprehensive Test Suite"
echo "=================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test results
PASSED=0
FAILED=0

# Function to run test suite
run_test_suite() {
  local suite_name=$1
  local test_path=$2
  
  echo ""
  echo "Running: ${suite_name}"
  echo "------------------------------------"
  
  if npm test -- "${test_path}" --reporter=verbose; then
    echo -e "${GREEN}✓ ${suite_name} PASSED${NC}"
    ((PASSED++))
  else
    echo -e "${RED}✗ ${suite_name} FAILED${NC}"
    ((FAILED++))
  fi
}

# Issue #1: Chaos Testing
run_test_suite \
  "Issue #1: Deterministic Chaos Test Suite" \
  "tests/chaos/comprehensive-chaos.spec.ts"

# Issue #2: Cursor Pagination
run_test_suite \
  "Issue #2: Stable Cursor Pagination" \
  "tests/pagination/comprehensive-pagination.spec.ts"

# Issue #3: Intent Approval
run_test_suite \
  "Issue #3: Maintainer Action Approval Flow" \
  "tests/intent/comprehensive-intent-approval.spec.ts"

# Issue #4: Multi-Actor Concurrency
run_test_suite \
  "Issue #4: Multi-Actor Concurrency Harness" \
  "tests/concurrency/comprehensive-concurrency.spec.ts"

# Summary
echo ""
echo "=================================="
echo "Test Summary"
echo "=================================="
echo -e "Passed: ${GREEN}${PASSED}${NC}"
echo -e "Failed: ${RED}${FAILED}${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}All test suites passed!${NC}"
  exit 0
else
  echo -e "${RED}Some test suites failed.${NC}"
  exit 1
fi
