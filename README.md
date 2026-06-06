# 🔀 Git Merge Conflict Demo & Resolver

A self-contained Bash script that **automatically creates a real Git repo, triggers a live merge conflict, and lets you resolve it interactively** — all from your terminal.

Built from scratch to understand what actually happens when two branches edit the same line.

---

## 💡 Why I Built This

Merge conflicts used to feel intimidating — that `<<<<<<< HEAD` screen is confusing the first time you see it.

Instead of just reading about it, I built a tool that **creates one on purpose** so you can practice resolving it in a safe, controlled environment.

---

## ⚙️ What It Does

```
STEP 1 → Creates a fresh Git repo at /tmp/git_conflict_demo
STEP 2 → Commits an initial story.txt file
STEP 3 → Creates branch-A and edits Line 2
STEP 4 → Creates branch-B from the same base commit and edits the SAME Line 2
STEP 5 → Merges branch-A cleanly (no conflict)
STEP 6 → Merges branch-B → CONFLICT triggered 💥
STEP 7 → You choose how to resolve it (3 options)
STEP 8 → Merge completed and final git log shown
```

---

## 🛠️ Resolution Options

When the conflict is detected, you get 3 choices:

| Option | Action |
|--------|--------|
| `1` | Keep **branch-A's** version → `the sun is SHINING bright` |
| `2` | Keep **branch-B's** version → `it is RAINING heavily` |
| `3` | Write your **own custom line** |

---

## 🚀 How to Run

**Requirements:** Git · Bash (Linux / macOS / WSL) · Python 3

```bash
# Clone the repo
git clone https://github.com/Anuragkumar-8680/git-conflict-demo.git
cd git-conflict-demo

# Give execute permission
chmod +x git_conflict_demo.sh

# Run it
bash git_conflict_demo.sh
```

---

## 📁 Project Structure

```
git-conflict-demo/
├── git_conflict_demo.sh   # Main script
└── README.md
```

---

## 🧠 Concepts Covered

- Git branching from a common base commit
- How merge conflicts are triggered
- What `<<<<<<< HEAD`, `=======`, `>>>>>>> branch-B` actually means
- Three conflict resolution strategies:
  - `git checkout --ours`
  - `git checkout --theirs`
  - Manual/custom resolution via Python regex
- Completing a merge with `git add` + `git commit`
- Reading `git log --oneline --graph --all`

---

## 🖥️ Tech Used

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![Python](https://img.shields.io/badge/Python3-3776AB?style=flat&logo=python&logoColor=white)

---

## 👤 Author

**Anurag Kumar** — 22BCE10856  
[GitHub](https://github.com/Anuragkumar-8680) · [LinkedIn](https://www.linkedin.com/in/anurag-kumar)

---

> ⭐ If this helped you understand merge conflicts, consider starring the repo!
