# Minecraft Spigot Server Setup Script

This script automates the setup of a Minecraft Spigot server on a Linux machine. It ensures that all necessary dependencies are installed, checks Java version, downloads and builds the specified Spigot version, and configures the server properties based on user input.

## Features
- Automatically installs required dependencies including `sudo`, `git`, `wget`, `screen`, and Zulu Java 21 if not present.
- Prompts the user to enter the Spigot version, game mode, difficulty, and MOTD.
- Downloads and builds the specified Spigot version using BuildTools.
- Automatically accepts the EULA.
- Configures `server.properties` based on user input.
- Runs the Minecraft server in a `screen` session to ensure it continues running after SSH disconnection.

## Prerequisites
- A Linux-based server with root (or sudo) access.

## Usage

1. **Download the script:**

   ```sh
   wget https://raw.githubusercontent.com/Fkstone/One-click-Spigot/main/setup_minecraft_server.sh
   ```

2. **Make the script executable:**

   ```sh
   chmod +x setup_minecraft_server.sh
   ```

3. **Run the script:**

   ```sh
   ./setup_minecraft_server.sh
   ```

4. **Follow the prompts to configure your server:**

   The script will ask you to enter:
   - The Spigot version you want to install (default: `1.20.1`)
   - The game mode (default: `survival`)
   - The difficulty (default: `normal`)
   - The MOTD (default: `A Minecraft Server`)

## Example

Here is an example of running the script:

```sh
./setup_minecraft_server.sh
```

You will see prompts like:

```sh
Enter the Spigot version you want to install [1.20.1]: 1.20.1
Enter the game mode (survival/creative/adventure/spectator) [survival]: survival
Enter the difficulty (peaceful/easy/normal/hard) [normal]: normal
Enter the MOTD for your server [A Minecraft Server]: My Awesome Server
```

After answering the prompts, the script will proceed to:

1. Install dependencies.
2. Download and build the specified Spigot version.
3. Configure the server.
4. Start the server in a `screen` session.

## Notes

- Ensure you have adequate permissions to install software and run scripts on your server.
- The script will automatically attach to the `screen` session running the Minecraft server. To detach from the session, press `Ctrl + A` followed by `D`. To reattach, use `screen -r minecraft_server`.

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Acknowledgements

- [SpigotMC](https://www.spigotmc.org/) for providing the Spigot server software.
- [Azul Systems](https://www.azul.com/) for providing Zulu Java distributions.
```
