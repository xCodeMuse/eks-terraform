#!/bin/bash

# Script to manage test reports
# Usage: ./manage_reports.sh [list|archive|cleanup|summary]

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section header
print_header() {
  echo -e "\n${YELLOW}======================================${NC}"
  echo -e "${YELLOW}$1${NC}"
  echo -e "${YELLOW}======================================${NC}\n"
}

# Function to list all test reports
list_reports() {
  print_header "Test Reports"
  
  if [ ! -d "../docs/test_reports" ] || [ -z "$(ls -A ../docs/test_reports 2>/dev/null)" ]; then
    echo -e "${RED}No test reports found in ../docs/test_reports/ directory${NC}"
    return
  fi
  
  echo -e "${BLUE}Basic Test Reports:${NC}"
  find ../docs/test_reports -name "test_report_*.md" -not -name "*mock*" | sort
  
  echo -e "\n${BLUE}Mock Test Reports:${NC}"
  find ../docs/test_reports -name "*mock*test_report*.md" | sort
  
  echo -e "\n${BLUE}Sample Reports:${NC}"
  find ../docs/test_reports -name "sample_*.md" | sort
}

# Function to archive test reports
archive_reports() {
  print_header "Archiving Test Reports"
  
  if [ ! -d "../docs/test_reports" ] || [ -z "$(ls -A ../docs/test_reports 2>/dev/null)" ]; then
    echo -e "${RED}No test reports found in ../docs/test_reports/ directory${NC}"
    return
  fi
  
  # Create archive directory if it doesn't exist
  mkdir -p ../docs/test_reports/archive
  
  # Get current date for archive name
  ARCHIVE_DATE=$(date +"%Y%m%d")
  ARCHIVE_NAME="test_reports_${ARCHIVE_DATE}.tar.gz"
  
  # Create archive
  tar -czf "../docs/test_reports/archive/${ARCHIVE_NAME}" -C ../docs/test_reports $(find ../docs/test_reports -maxdepth 1 -name "*.md" -not -path "*/archive/*" | xargs -n 1 basename)
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Test reports archived to ../docs/test_reports/archive/${ARCHIVE_NAME}${NC}"
    
    # Ask if user wants to remove original files
    read -p "Do you want to remove the original report files? (y/n): " REMOVE_ORIGINALS
    if [[ $REMOVE_ORIGINALS =~ ^[Yy]$ ]]; then
      find ../docs/test_reports -maxdepth 1 -name "*.md" -not -path "*/archive/*" -delete
      echo -e "${GREEN}Original report files removed${NC}"
    fi
  else
    echo -e "${RED}Failed to archive test reports${NC}"
  fi
}

# Function to clean up old test reports
cleanup_reports() {
  print_header "Cleaning Up Old Test Reports"
  
  if [ ! -d "../docs/test_reports" ] || [ -z "$(ls -A ../docs/test_reports 2>/dev/null)" ]; then
    echo -e "${RED}No test reports found in ../docs/test_reports/ directory${NC}"
    return
  fi
  
  # Ask for days threshold
  read -p "Remove reports older than how many days? (default: 30): " DAYS_THRESHOLD
  DAYS_THRESHOLD=${DAYS_THRESHOLD:-30}
  
  # Find and remove old reports
  OLD_REPORTS=$(find ../docs/test_reports -maxdepth 1 -name "test_report_*.md" -mtime +${DAYS_THRESHOLD})
  
  if [ -z "$OLD_REPORTS" ]; then
    echo -e "${GREEN}No reports older than ${DAYS_THRESHOLD} days found${NC}"
    return
  fi
  
  echo -e "${BLUE}The following reports will be removed:${NC}"
  echo "$OLD_REPORTS"
  
  read -p "Proceed with removal? (y/n): " CONFIRM_REMOVAL
  if [[ $CONFIRM_REMOVAL =~ ^[Yy]$ ]]; then
    find ../docs/test_reports -maxdepth 1 -name "test_report_*.md" -mtime +${DAYS_THRESHOLD} -delete
    echo -e "${GREEN}Old reports removed successfully${NC}"
  else
    echo -e "${YELLOW}Cleanup cancelled${NC}"
  fi
}

# Function to generate a summary of test reports
summary_reports() {
  print_header "Test Reports Summary"
  
  if [ ! -d "../docs/test_reports" ] || [ -z "$(ls -A ../docs/test_reports 2>/dev/null)" ]; then
    echo -e "${RED}No test reports found in ../docs/test_reports/ directory${NC}"
    return
  fi
  
  # Count reports by type
  BASIC_COUNT=$(find ../docs/test_reports -maxdepth 1 -name "test_report_*.md" -not -name "*mock*" | wc -l)
  MOCK_COUNT=$(find ../docs/test_reports -maxdepth 1 -name "*mock*test_report*.md" | wc -l)
  SAMPLE_COUNT=$(find ../docs/test_reports -maxdepth 1 -name "sample_*.md" | wc -l)
  TOTAL_COUNT=$((BASIC_COUNT + MOCK_COUNT + SAMPLE_COUNT))
  
  # Get newest and oldest reports (more portable version)
  NEWEST_REPORT=$(find ../docs/test_reports -maxdepth 1 -name "test_report_*.md" -type f | xargs ls -t 2>/dev/null | head -1)
  OLDEST_REPORT=$(find ../docs/test_reports -maxdepth 1 -name "test_report_*.md" -type f | xargs ls -tr 2>/dev/null | head -1)
  
  # Get newest report date
  if [ -n "$NEWEST_REPORT" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      NEWEST_DATE=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$NEWEST_REPORT")
    else
      NEWEST_DATE=$(stat -c "%y" "$NEWEST_REPORT" | cut -d. -f1)
    fi
  else
    NEWEST_DATE="N/A"
  fi
  
  # Get oldest report date
  if [ -n "$OLDEST_REPORT" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      OLDEST_DATE=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$OLDEST_REPORT")
    else
      OLDEST_DATE=$(stat -c "%y" "$OLDEST_REPORT" | cut -d. -f1)
    fi
  else
    OLDEST_DATE="N/A"
  fi
  
  # Print summary
  echo -e "${BLUE}Total Reports:${NC} $TOTAL_COUNT"
  echo -e "${BLUE}Basic Test Reports:${NC} $BASIC_COUNT"
  echo -e "${BLUE}Mock Test Reports:${NC} $MOCK_COUNT"
  echo -e "${BLUE}Sample Reports:${NC} $SAMPLE_COUNT"
  echo -e "${BLUE}Newest Report:${NC} $NEWEST_REPORT ($NEWEST_DATE)"
  echo -e "${BLUE}Oldest Report:${NC} $OLDEST_REPORT ($OLDEST_DATE)"
  
  # Check for archives
  ARCHIVE_COUNT=$(find ../docs/test_reports/archive -name "*.tar.gz" 2>/dev/null | wc -l)
  if [ $ARCHIVE_COUNT -gt 0 ]; then
    echo -e "${BLUE}Archives:${NC} $ARCHIVE_COUNT"
  fi
}

# Main execution
if [ $# -eq 0 ]; then
  # No arguments, show usage
  print_header "Test Reports Management"
  echo -e "Usage: $0 [list|archive|cleanup|summary]"
  echo -e ""
  echo -e "${BLUE}Commands:${NC}"
  echo -e "  list     - List all test reports"
  echo -e "  archive  - Archive test reports"
  echo -e "  cleanup  - Remove old test reports"
  echo -e "  summary  - Show summary of test reports"
  exit 0
fi

# Process command
case "$1" in
  list)
    list_reports
    ;;
  archive)
    archive_reports
    ;;
  cleanup)
    cleanup_reports
    ;;
  summary)
    summary_reports
    ;;
  *)
    echo -e "${RED}Unknown command: $1${NC}"
    echo -e "Usage: $0 [list|archive|cleanup|summary]"
    exit 1
    ;;
esac