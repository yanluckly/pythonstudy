# BAPI Reference Guide

## BAPI_USER_CREATE1

Create a new SAP user.

### Key Parameters

| Parameter | Type | Direction | Description |
|-----------|------|-----------|-------------|
| USERNAME | BAPIBNAME-BAPIBNAME | IMPORT | User ID (max 12 chars) |
| LOGONDATA | BAPILOGOND | IMPORT | Logon data (user type, etc.) |
| PASSWORD | BAPIPWD-BAPIPWD | IMPORT | Initial password |
| ADDRESS | BAPIADDR3 | IMPORT | Address data |
| DEFAULTS | BAPIDEFAUL | IMPORT | User defaults (spool, date format, etc.) |
| RETURN | BAPIRET2 | TABLES | Return messages |

### BAPILOGOND Key Fields
- `USTYP`: User type ('A' = dialog user)
- `CLASS`: User group

### BAPIADDR3 Key Fields
- `TITLE_P`: Title (Mr., Ms., etc.)
- `FIRSTNAME`: First name
- `LASTNAME`: Last name
- `DEPARTMENT`: Department
- `TEL1_NUMBR`: Phone number
- `E_MAIL`: Email address
- `CITY`: City
- `SORT1`: Search term

### BAPIDEFAUL Key Fields
- `SPLD`: Default printer
- `DCPFM`: Decimal format
- `DATFM`: Date format

## ISAI_USER_ROLES_MAINTAIN

Assign roles to an existing SAP user.

### Key Parameters

| Parameter | Type | Direction | Description |
|-----------|------|-----------|-------------|
| USERNAME | BAPIBNAME-BAPIBNAME | IMPORT | User ID |
| ACTGROUPS_NEW | BAPIAGR | TABLES | Roles to assign |
| RETURN_STATUS | BAPI_MTYPE | EXPORT | Overall status ('E'/'A' = error) |
| RETURN | BAPIRET2 | TABLES | Return messages |

### BAPIAGR Key Fields
- `AGR_NAME`: Role name (e.g., 'Z_BC_ADMIN')

## BAPI_TRANSACTION_COMMIT

Commit a BAPI transaction. **Must** be called after successful BAPI operations.

### Key Parameters
| Parameter | Type | Direction | Description |
|-----------|------|-----------|-------------|
| WAIT | CHAR1 | IMPORT | 'X' = wait for commit to complete |

## BAPI_TRANSACTION_ROLLBACK

Rollback a BAPI transaction. Called when BAPI returns errors.

No parameters required.

## ALSM_EXCEL_TO_INTERNAL_TABLE

Import Excel file content into an internal table.

### Key Parameters

| Parameter | Type | Direction | Description |
|-----------|------|-----------|-------------|
| FILENAME | RLGRAP-FILENAME | IMPORT | Excel file path |
| I_BEGIN_COL | KCD_EX_COL_N | IMPORT | Start column |
| I_BEGIN_ROW | KCD_EX_COL_N | IMPORT | Start row |
| I_END_COL | KCD_EX_COL_N | IMPORT | End column (max 2560) |
| I_END_ROW | KCD_EX_COL_N | IMPORT | End row (max 2560) |
| INTERN | ALSMEX_TABLINE | TABLES | Result table with ROW/COL/VALUE |

### Result Structure (ALSMEX_TABLINE)
- `ROW`: Row number (char 4)
- `COL`: Column number (char 4)
- `VALUE`: Cell value (char 50)

## REUSE_ALV_GRID_DISPLAY

Display data in ALV grid format.

### Key Parameters

| Parameter | Type | Direction | Description |
|-----------|------|-----------|-------------|
| I_CALLBACK_PROGRAM | SY-REPID | IMPORT | Calling program |
| I_CALLBACK_PF_STATUS_SET | SLIS_FORMNAME | IMPORT | Form for PF-STATUS |
| I_CALLBACK_USER_COMMAND | SLIS_FORMNAME | IMPORT | Form for user commands |
| IS_LAYOUT | SLIS_LAYOUT_ALV | IMPORT | Layout settings |
| I_SAVE | CHAR1 | IMPORT | 'A' = all layouts saveable |
| IT_FIELDCAT | SLIS_FIELDCAT_ALV | TABLES | Field catalog |
| T_OUTTAB | Standard Table | TABLES | Output data table |

### SLIS_LAYOUT_ALV Key Fields
- `COLWIDTH_OPTIMIZE`: 'X' = auto-optimize column width
- `BOX_FIELDNAME`: Field name for checkbox selection

### SLIS_FIELDCAT_ALV Key Fields
- `FIELDNAME`: Internal field name
- `SELTEXT_L/M/S`: Column header (long/medium/short)
- `COL_POS`: Column position
- `OUTPUTLEN`: Output length
- `JUST`: Alignment ('L'/'R'/'C')
- `ICON`: 'X' = display as icon

## Common SAP Transactions for Development

| TCode | Purpose |
|-------|---------|
| SE38 | ABAP Editor |
| SE80 | Object Navigator |
| SE93 | Maintain Transactions |
| SE41 | Menu Painter (PF-STATUS) |
| SE51 | Screen Painter |
| SMW0 | Web Repository (upload templates) |
| SU01 | User Maintenance |
| SU10 | Mass User Changes |
| PFCG | Role Maintenance |
| SE11 | Data Dictionary |
| SE16 | Table Browser |
| ST22 | Dump Analysis |
