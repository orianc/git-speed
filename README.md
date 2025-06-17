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

In any Git repository, simply type:

```bash
gitc
```

The interactive interface will guide you through creating your commit.

### Supported Commit Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the code (whitespace, formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding missing tests
- `chore`: Changes to the build process or auxiliary tools
- `revert`: Revert a previous commit

## Uninstallation 🗑️

To remove the alias, delete the following line from your `~/.zshrc` or `~/.bashrc` file:

```bash
alias gitc='/path/to/git-speed/commit.sh'
```

## Customization 🎨

You can customize the colors and style by directly modifying the `commit.sh` script.

## Contributing 🤝

Contributions are welcome! Feel free to open an issue or submit a pull request.

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
