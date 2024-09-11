# carbon-now

carbon-now is a Bash script that generates a Carbon Now URL for creating code snippet images. It allows users to configure various parameters, such as font size, theme, background color, and more, using a JSON configuration file or command-line options.

## Versions
**Current version**: 0.3.0

## Table of Contents
- [Versions](#versions)
- [Badges](#badges)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)
- [Contributing](#contributing)

## Badges
![Shell](https://img.shields.io/badge/Shell-Bash-blue)
![Version](https://img.shields.io/badge/Version-0.3.0-brightgreen)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow)

## Installation

To use `carbon-now` on your machine, follow these steps:

1. Install `jq` (a lightweight JSON processor) using Homebrew (for MacOS users):
   ```bash
   brew install jq
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/beecave-homelab/carbon-now.git
   cd carbon-now
   ```

3. Ensure that `carbon-now.sh` is executable:
   ```bash
   chmod +x carbon-now.sh
   ```

## Usage

You can use `carbon-now` to generate Carbon Now URLs with configurable settings. Here are some example usages:

- To generate a Carbon Now URL with a code snippet as input:
  ```bash
  ./carbon-now.sh --input 'print("Hello, World!")' 
  ```

- To specify a configuration file for custom parameters:
  ```bash
  ./carbon-now.sh --input /path/to/code.py --config config/custom-onelight.json
  ```

- To generate a Carbon Now URL and an embeddable URL:
  ```bash
  ./carbon-now.sh --input 'print("Hello, World!")' --embed
  ```

For more options and details, run:
```bash
./carbon-now.sh --help
```

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more information.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.