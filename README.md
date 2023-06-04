# PlacementioCodingChallenge

### Implement Parts

Bucket 1:
- The user should be able browse through the line-item data as either a list or table (ie. pagination or infinite-scrolling).
- The user should be able to edit line-item "adjustments".
- The user should be able to see each line-item's billable amount (sub-total = actuals + adjustments).
- The user should be able to see sub-totals grouped by campaign (line-items grouped by their parent campaign).
- The user should be able to see the invoice grand-total (sum of each line-item's billable amount).
- The user should be able to sort the data.
- The user should be able to output the invoice to *.CSV, *.XLS, etc.
- The user should be able flag individual line-items as "reviewed" (meaning they are disabled from further editing).
- The user should be able flag "campaigns" as being reviewed, as well.

Bucket 2:
- An integration into an external service that makes sense (eg. a currency conversion service, an export to Amazon S3, etc)
- The user should be able to filter the data (ie. by campaign name, etc., should affect the grand-total).

## Implement Details and Thought Process

- Becausce I am more familiar with backend development, I focus on functionality instead of frontend/UI/UX.
- I chose to use built-in Rails MVC structure and server-side-render for the assignments.
- Design RESTful endpoint for basic CRUD function.
- Seperate the main logic to service object instead of put on controller. Also write rspec for each service object.
- Calculate billable amount/sub-totals/grand-total dynamically:
  - Ensure that it stays accurate and reflects any changes in the actual_amount or adjustments.
  - Storing it as a separate column would require additional management to keep it synchronized with the actual data.

- For exporting CVS/XLS function
  - Using Tempfile ensures that each request has its own unique temporary file, avoiding race conditions and eliminating the need for manual cleanup.
- For intergation with Exchange rate API (https://www.exchangerate-api.com/docs/standard-requests)
  - Using an environment variable for the API key ensures secure handling of sensitive information.
  - Caching conversion rates: caches the conversion rates to improve performance and reduce API requests.
  - Error handling: raises a ConversionRateUnavailableError if the requested conversion rate is not available or cannot be fetched from the API. Logging errors and falling back to default conversion rates.

## How to use

Following provides the necessary steps to get the PlacementioCodingChallenge application up and running.

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

### 6. Setup Environment Variables

CurrencyConversionService will use the EXCHANGE_RATE_API_KEY

I store the EXCHANGE_RATE_API_KEY in .env and add it to .gitignore

so you need to use following commands to generate .env file

```shell
cp .env.example .env
```

### 7. Start the Rails server:

```shell
rails server
```

The server will start running at http://127.0.0.1:3000.

Go to http://127.0.0.1:3000/campaigns will see the campaigns list 


## Test 

Run all the rspec

```shell
bundle exec rspec
```
