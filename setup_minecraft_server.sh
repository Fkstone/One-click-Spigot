#!/bin/bash

# Function to display a message and read input
function prompt() {
    local message="$1"
    local default="$2"
    read -p "$message [$default]: " input
    echo "${input:-$default}"
}

# Color codes
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if sudo is installed
if ! command -v sudo &> /dev/null; then
    echo -e "${RED}sudo is not installed. Installing sudo...${NC}"
    apt update && apt install -y sudo
    if ! command -v sudo &> /dev/null; then
        echo -e "${RED}Error: Failed to install sudo. Please install sudo manually and re-run the script.${NC}"
        exit 1
    fi
fi

# Function to install Zulu Java 21
function install_java() {
    echo -e "${BLUE}Java is not installed or version is less than 21. Installing Zulu Java 21...${NC}"
    
    # Install required packages
    sudo apt install -y gnupg ca-certificates curl
    
    # Import Azul’s public key
    curl -s https://repos.azul.com/azul-repo.key | sudo gpg --dearmor -o /usr/share/keyrings/azul.gpg
    
    # Add Azul repository to the list
    echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | sudo tee /etc/apt/sources.list.d/zulu.list
    
    # Update package information
    sudo apt update
    
    # Install Zulu Java 21
    sudo apt install -y zulu21-jdk
}

# Ensure required packages are installed
function install_dependencies() {
    echo -e "${BLUE}Installing required dependencies...${NC}"
    sudo apt update
    sudo apt install -y git wget screen
}

# Ensure Java is installed and version is 21 or higher
if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | awk -F[\".] 'NR==1{print $2}')
    if ((java_version < 21)); then
        install_java
    else
        echo -e "${BLUE}Java version is $java_version.${NC}"
    fi
else
    install_java
fi

# Ensure git, wget, and screen are installed
if ! command -v git &> /dev/null || ! command -v wget &> /dev/null || ! command -v screen &> /dev/null; then
    install_dependencies
else
    echo -e "${BLUE}git, wget, and screen are already installed.${NC}"
fi

# Prompt user for Spigot version
spigot_version=$(prompt "Enter the Spigot version you want to install" "1.20.1")

# Download BuildTools.jar
if [ ! -f BuildTools.jar ]; then
    echo -e "${BLUE}Downloading BuildTools.jar...${NC}"
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
fi

# Build Spigot
echo -e "${BLUE}Building Spigot version $spigot_version...${NC}"
java -jar BuildTools.jar --rev $spigot_version

# Check if the build was successful
if [ ! -f spigot-$spigot_version.jar ]; then
    echo -e "${RED}Error: Failed to build Spigot version $spigot_version.${NC}"
    exit 1
fi

# Create server directory
mkdir -p minecraft_server
cd minecraft_server || exit 1

# Move spigot jar to server directory
mv ../spigot-$spigot_version.jar spigot.jar

# Run spigot jar to generate initial files
echo -e "${BLUE}Starting the server for the first time to generate files...${NC}"
java -jar spigot.jar nogui

# Automatically accept EULA
echo "eula=true" > eula.txt

# Prompt user for server properties
gamemode=$(prompt "Enter the game mode (survival/creative/adventure/spectator)" "survival")
difficulty=$(prompt "Enter the difficulty (peaceful/easy/normal/hard)" "normal")
motd=$(prompt "Enter the MOTD for your server" "A Minecraft Server")

# Update server.properties file
sed -i "s/^gamemode=.*/gamemode=$gamemode/" server.properties
sed -i "s/^difficulty=.*/difficulty=$difficulty/" server.properties
sed -i "s/^motd=.*/motd=$motd/" server.properties

# Start the server in a screen session
echo -e "${BLUE}Starting the Minecraft server with the specified settings in a screen session...${NC}"
screen -dmS minecraft_server java -jar spigot.jar nogui

echo -e "${BLUE}The Minecraft server is now running in a screen session named 'minecraft_server'.${NC}"
echo -e "${BLUE}Automatically attaching to the screen session...${NC}"
screen -r minecraft_server