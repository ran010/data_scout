# DataScout

**DataScout** is a Ruby command-line application that helps you **search client data** (from a JSON file or URL) and **detect duplicate emails**. Designed for extensibility and easy usage, it provides dynamic search capabilities by any attribute like `full_name`, `email`, or `id`.

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/ran010/data_scout.git
cd data_scout
```

### 2. Install Dependencies

Make sure you have Ruby installed (recommended: >= 2.6). Then run:

```bash
bundle install
```

### 3. Configure .env

- Create a file named .env in the root folder.
- Add the following line to define the API endpoint:
  DATA_API_ENDPOINT=https://appassets02.shiftcare.com/manual/clients.json

### 4. Run the CLI

You can execute the CLI directly from the command line:

```bash
ruby bin/data_scout.rb
```

### 5. Usage Examples

```bash
search John
id: 1 full_name: John Doe email: john.doe@gmail.com
id: 3 full_name: Alex Johnson email: alex.johnson@hotmail.com

search john.doe@gmail.com email
id: 1 full_name: John Doe email: john.doe@gmail.com

duplicates
Duplicate emails found:
jane.smith@yahoo.com appears 2 times

exit
```

### 6. Run spec

```bash
rspec spec
```

### Known Limitations

- Large files: The current approach loads the full JSON file into memory, which may not scale well with millions of records. For very large files, a streaming approach or database-backed loader would be more appropriate.
- Search Functionality: The search is implemented using a simple include? check, meaning it performs a case-insensitive partial match against the provided keyword.

- CLI Limitation: The current implementation is designed exclusively for command-line interface (CLI) usage and is not structured for integration as a library in other applications or scripts.

### Future Improvements

- Implement stronger schema validation to ensure the data adheres to a defined structure and is error-free.
- Introduce fuzzy search or regex-based search options to allow more flexible and robust querying of data.

- Implement more robust error handling, especially for scenarios like invalid JSON format, failed API calls, or missing fields in the data.
- Support for Pagination, since Many APIs return data in paginated form.
- Modularization and Separation of Concerns: Refactor into smaller, more cohesive modules: Break down the current implementation into well-defined modules. For example: DataLoader, ClientSearch, DuplicateChecker.
- Introduce a Service Layer to interact with external services (such as APIs), introduce a Service layer to manage these interactions
