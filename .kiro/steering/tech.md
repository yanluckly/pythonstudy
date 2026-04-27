# Technology Stack

## Programming Languages
- **Python 3.x** - Primary language for scripts
- **ABAP** - SAP programming language for enterprise applications

## Python Libraries & Frameworks
- **requests** - HTTP library for web scraping
- **BeautifulSoup4** - HTML parsing library
- **Standard Library** - Core Python modules

## SAP Components
- **BAPI_USER_CREATE1** - User creation function module
- **ISAI_USER_ROLES_MAINTAIN** - Role assignment function module
- **ALSM_EXCEL_TO_INTERNAL_TABLE** - Excel import function module
- **REUSE_ALV_GRID_DISPLAY** - ALV grid display function module

## Build System & Tools
- **No formal build system** - Scripts are standalone
- **Python virtual environments** recommended for dependency management
- **SAP GUI/ABAP Development Tools** for ABAP development

## Common Commands

### Python Development
```bash
# Install dependencies
pip install requests beautifulsoup4

# Run Python scripts
python testforgg01.py
python "abc=28.py"
python "爬取天气.py"
```

### ABAP Development
- **Transaction SE38** - ABAP Editor for ZBC001 program
- **Transaction SE80** - Object Navigator
- **Transaction SMW0** - Template management for Excel templates

## Development Environment
- **Windows** - Primary operating system
- **SAP GUI** - For ABAP program execution
- **Python 3.7+** - For Python scripts
- **VS Code** or **PyCharm** - Recommended Python IDE

## Dependencies
- Python: requests, beautifulsoup4
- SAP: Standard SAP system with appropriate authorizations
- Excel: For data import templates