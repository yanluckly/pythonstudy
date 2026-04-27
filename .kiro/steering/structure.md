# Project Organization

## Folder Structure
```
.
├── .git/                    # Git version control
├── .kiro/
│   └── steering/           # Kiro steering documents
├── .vscode/                # VS Code configuration
├── abc=28.py               # Mathematical puzzle solver
├── testforgg01.py          # Leap year calculator
├── 爬取天气.py              # Weather data scraper
└── zbc001.prog.abap        # SAP user role assignment program
```

## File Descriptions

### Python Scripts
- **testforgg01.py** - Simple leap year calculation with test cases
- **abc=28.py** - Mathematical optimization problem solver with palindrome checker
- **爬取天气.py** - Chinese weather website scraper using requests and BeautifulSoup

### ABAP Program
- **zbc001.prog.abap** - Comprehensive SAP program for batch user creation and role assignment

## Code Organization Patterns

### Python Code Style
- Functions with docstrings for documentation
- Simple, readable code structure
- Chinese variable names in weather scraper
- Test cases included in scripts

### ABAP Code Style
- Standard SAP naming conventions (Z-prefix for custom programs)
- Modular structure with FORM routines
- ALV grid for user interface
- Comprehensive error handling
- Chinese language support in user interface

## Architecture Patterns

### Python Scripts
- **Standalone scripts** - Each file is independent
- **Functional programming** - Simple functions with clear inputs/outputs
- **Web scraping pattern** - Requests + BeautifulSoup for data extraction

### ABAP Program
- **Batch processing** - Excel import → data processing → user operations
- **Modular design** - Separate FORMs for different functionalities
- **Transaction safety** - Commit/rollback for database operations
- **User feedback** - ALV grid display with success indicators

## Development Guidelines
1. Keep Python scripts focused on single responsibilities
2. Maintain ABAP program's modular structure when extending
3. Add docstrings to Python functions
4. Follow SAP naming conventions for ABAP objects
5. Test scripts with sample data before deployment