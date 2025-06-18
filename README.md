# Git CC 🚀

A command-line tool to quickly and easily create conventional Git commits with an interactive interface.

## Features ✨

- Interactive and user-friendly interface
- Follows Conventional Commits specification
- Supports standard commit types (feat, fix, docs, etc.)
- Handles scopes and breaking changes
- Git repository status verification

## Prerequisites 📋

- Git
- [gum](https://github.com/charmbracelet/gum) - A command-line tool for creating elegant user interfaces

## Installation 🛠️

### Using Homebrew (recommended)

```bash
# Add the tap if you haven't already
brew tap orianc/tap

# Install git-cc
brew install git-cc
```

### Manual Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/orianc/git-speed.git
   cd git-speed
   ```

2. Make the installation script executable and run it:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. Restart your terminal or run:
   ```bash
   source ~/.zshrc  # or ~/.bashrc depending on your shell
   ```

## Usage 🚀

Simply run:

```bash
gitc
```

Then follow the interactive prompts to create your conventional commit.

### Supported Commit Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the code (whitespace, formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding missing tests
- `chore`: Changes to the build process or auxiliary tools
- `revert`: Revert a previous commit

## Customization 🎨

You can customize the colors and style by directly modifying the `bin/gitc` script.

## Contributing 🤝

Contributions are welcome! Feel free to open an issue or submit a pull request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
