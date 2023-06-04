# PlacementioCodingChallenge

This README provides the necessary steps to get the PlacementioCodingChallenge application up and running.

## Ruby version

- Ruby 3.2.2

## System dependencies

- PostgreSQL 14.8

## Installation

### 1. Clone the repository:

```shell
  git clone git@github.com:boypie510/placementsio_coding_challenge.git
```

### 2. Install Ruby:

- Ruby / Gem Setup
First, make sure you are in the root directory of the placementsio_coding_challenge repository:

```shell
$ cd ~/YOUR/PATH/TO/placementsio_coding_challenge
```

#### 2.1 Install rbenv:

```shell
$ brew install rbenv
```

Add the following script to your ~/.zshrc file:
```shell
eval "$(rbenv init - zsh)"
```

Based on the Ruby version specified in the Gemfile, create a .ruby-version file:

```
$ echo "3.2.2" > .ruby-version
```
Install the Ruby version specified in the .ruby-version file in the root directory. After restarting your shell, rbenv should switch to that version:

```shell
$ rbenv install
$ exec $SHELL
```
You have now successfully set up Ruby using rbenv.

### 3. Install PostgreSQL

#### 3.1 Install Homebrew:

If the you don't have Homebrew installed, run the following command in the terminal:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 3.2 Install PostgreSQL: Instruct the user to install PostgreSQL using Homebrew by running the following command:

```shell
brew install postgresql@14.8
```
This will install the specified version of PostgreSQL (14.8) using Homebrew.

Start and enable the PostgreSQL service: Instruct the user to start and enable the PostgreSQL service by running the following command:
```shell
brew services start postgresql@14.8
```
This will start the PostgreSQL service and configure it to start automatically on system boot.

Verify the installation:you can run the following command:
```shell
psql --version
```
This should display the version of PostgreSQL installed on their system, which should match the specified version (14.8).

### 4. Install dependencies:

```shell
bundle install
```

### 5. DataBase setup

Set up the PostgreSQL database. Ensure you have PostgreSQL installed and running on your system. Then, run the following commands to create and initialize the database:

```shell
rails db:setup
```

### 6. Start the Rails server:

```shell
rails server
```

The server will start running at http://127.0.0.1:3000.

Go to http://127.0.0.1:3000/campaigns will see the campaigns list 
