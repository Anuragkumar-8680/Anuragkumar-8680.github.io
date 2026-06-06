#!/bin/bash

# ─────────────────────────────────────────────
#   Git Merge Conflict Demo & Resolver
#   Author: Crafted for Anurag Kumar
# ─────────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

print_step()    { echo -e "\n${CYAN}${BOLD}>>> $1${RESET}"; }
print_success() { echo -e "${GREEN}✔ $1${RESET}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${RESET}"; }
print_error()   { echo -e "${RED}✘ $1${RESET}"; }

# ─── STEP 1: Setup fresh repo ───
print_step "STEP 1: Setting up a fresh Git repository..."
REPO_DIR="/tmp/git_conflict_demo"
rm -rf "$REPO_DIR"
mkdir "$REPO_DIR"
cd "$REPO_DIR"
git init -q
git config user.email "demo@example.com"
git config user.name "Demo User"
print_success "Repo created at $REPO_DIR"

# ─── STEP 2: Create initial file ───
print_step "STEP 2: Creating initial file and committing..."
cat << 'FILECONTENT' > story.txt
Line 1: The sky is clear today.
Line 2: This line will cause a conflict.
Line 3: Everything is peaceful.
FILECONTENT

git add story.txt
git commit -q -m "Initial commit"
DEFAULT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
print_success "Initial file committed on '$DEFAULT_BRANCH'"

# ─── STEP 3: branch-A ───
print_step "STEP 3: Creating 'branch-A' and editing Line 2..."
git checkout -q -b branch-A
sed -i 's/Line 2: This line will cause a conflict./Line 2: Branch-A says the sun is SHINING bright!/' story.txt
git add story.txt
git commit -q -m "branch-A: Updated Line 2"
print_success "branch-A committed"

# ─── STEP 4: branch-B from initial commit ───
print_step "STEP 4: Creating 'branch-B' from initial commit and editing SAME Line 2..."
INITIAL_COMMIT=$(git log --oneline | tail -1 | awk '{print $1}')
git checkout -q "$INITIAL_COMMIT" 2>/dev/null
git checkout -q -b branch-B
sed -i 's/Line 2: This line will cause a conflict./Line 2: Branch-B says it is RAINING heavily!/' story.txt
git add story.txt
git commit -q -m "branch-B: Updated Line 2"
print_success "branch-B committed"

# ─── STEP 5: Merge branch-A into default (clean) ───
print_step "STEP 5: Merging 'branch-A' into '$DEFAULT_BRANCH' (clean merge)..."
git checkout -q "$DEFAULT_BRANCH"
git merge branch-A -q -m "Merge branch-A"
print_success "branch-A merged — no conflict!"

# ─── STEP 6: Merge branch-B — triggers conflict ───
print_step "STEP 6: Attempting to merge 'branch-B' — conflict incoming..."
git merge branch-B 2>/dev/null

if [ $? -ne 0 ]; then
    echo ""
    print_warning "MERGE CONFLICT DETECTED in: story.txt"
    echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}  Conflicting file content:${RESET}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    cat story.txt
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

    # ─── STEP 7: User decision ───
    print_step "STEP 7: How do you want to resolve the conflict?"
    echo -e "  ${BOLD}[1]${RESET} Keep ${GREEN}branch-A${RESET} → 'the sun is SHINING bright'"
    echo -e "  ${BOLD}[2]${RESET} Keep ${YELLOW}branch-B${RESET} → 'it is RAINING heavily'"
    echo -e "  ${BOLD}[3]${RESET} Write ${CYAN}your own custom line${RESET}"
    echo ""
    read -p "Enter your choice (1/2/3): " CHOICE

    case $CHOICE in
        1)
            git checkout --ours story.txt
            print_success "Resolved! Keeping branch-A's version."
            ;;
        2)
            git checkout --theirs story.txt
            print_success "Resolved! Keeping branch-B's version."
            ;;
        3)
            echo ""
            read -p "Type your custom Line 2: " CUSTOM_LINE
            python3 -c "
import re
content = open('story.txt').read()
content = re.sub(r'<<<<<<< HEAD\n.*?\n=======\n.*?\n>>>>>>> branch-B\n', 'Line 2: ${CUSTOM_LINE}\n', content, flags=re.DOTALL)
open('story.txt', 'w').write(content)
"
            print_success "Resolved! Your custom line has been used."
            ;;
        *)
            print_error "Invalid choice. Aborting."
            git merge --abort
            exit 1
            ;;
    esac

    # ─── STEP 8: Complete merge ───
    print_step "STEP 8: Completing the merge..."
    git add story.txt
    git commit -q -m "Resolved merge conflict"
    print_success "Merge completed!"
else
    print_warning "No conflict — branches already in sync."
fi

# ─── Final output ───
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}  Final content of story.txt:${RESET}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
cat story.txt
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

print_step "Final Git Log:"
git log --oneline --graph --all

echo ""
print_success "Demo complete! You just handled a real Git merge conflict. 🔥"
echo ""
