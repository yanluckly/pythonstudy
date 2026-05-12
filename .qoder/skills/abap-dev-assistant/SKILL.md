---
name: abap-dev-assistant
description: Assist with ABAP/SAP development tasks including code generation, review, debugging, and best practices. Use when working with .abap files, SAP function modules (BAPI), ALV grid programs, user management, or when the user mentions ABAP, SAP, BAPI, ALV, role assignment, user creation, or any SAP-related development task.
---

# ABAP Development Assistant

## When to Apply

Automatically activate when:
- User is editing or creating `.abap` files
- User mentions SAP transactions (SE38, SE80, SE93, SMW0, SU01, etc.)
- User asks about BAPI function modules, ALV grid, or SAP user management
- User needs help with ABAP code patterns, debugging, or optimization

## Project ABAP Conventions

### Naming Standards
- Custom programs: `Z` or `Y` prefix (e.g., `ZBC001`)
- Message class: `Z` prefix (e.g., `MESSAGE-ID ZBC`)
- Custom transactions: `Z` or `Y` prefix
- Variables: `L_` for local, `LT_` for local tables, `LS_` for local structures, `WA_` for work areas, `WT_` for global tables
- Forms: Descriptive English names (e.g., `CREATE_USER`, `ADD_ROLE`, `GET_DATA`)

### File Header Template
```abap
*&---------------------------------------------------------------------*
*& Report  ZXXXXX                                                      *
*&---------------------------------------------------------------------*
*& Author              :                                               *
*& Create Date         : YYYY/MM/DD                                    *
*& Description         : [Chinese description]                         *
*& <Function Spec      :                                               *
*& Modifications       :                                               *
*&   Date        Programmer   <需求说明号>    Description               *
*&   YYYY/MM/DD  修改人员名   <xxxxx>         说明                      *
*&---------------------------------------------------------------------*
```

### Code Structure Order
1. `REPORT` statement with `MESSAGE-ID`
2. `TABLES` and `TYPE-POOLS` declarations
3. MACRO definitions
4. Constants (`CONSTANTS`)
5. Type declarations (`TYPES`)
6. Internal tables and data declarations
7. Selection screen (`PARAMETERS`, `SELECT-OPTIONS`, `SELECTION-SCREEN`)
8. Events: `INITIALIZATION` → `AT SELECTION-SCREEN OUTPUT` → `AT SELECTION-SCREEN` → `START-OF-SELECTION` → `END-OF-SELECTION`
9. FORM routines

## Key Patterns

### ALV Grid Display
Use `REUSE_ALV_GRID_DISPLAY` with macro for field catalog:

```abap
DEFINE MCR_ALV.
  it_fieldcat-fieldname = &1.
  it_fieldcat-seltext_l = &2.
  it_fieldcat-seltext_m = &2.
  it_fieldcat-seltext_s = &2.
  it_fieldcat-col_pos   = &3.
  it_fieldcat-outputlen = &4.
  it_fieldcat-just      = &5.
  it_fieldcat-icon      = &6.
  APPEND it_fieldcat.
  CLEAR it_fieldcat.
END-OF-DEFINITION.
```

Set PF-STATUS and USER_COMMAND callbacks for interactive ALV.

### BAPI Transaction Pattern
Always pair BAPI calls with commit/rollback:

```abap
CALL FUNCTION 'BAPI_USER_CREATE1'
  EXPORTING
    USERNAME  = L_USERNAME
    LOGONDATA = L_LOGONDATA
    PASSWORD  = L_PASSWORD
    ADDRESS   = L_ADDRESS
  TABLES
    RETURN    = LT_RETURN.

READ TABLE LT_RETURN INDEX 1.
IF LT_RETURN-TYPE = 'S'.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING WAIT = 'X'.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
ENDIF.
```

### Excel Import Pattern
Use `ALSM_EXCEL_TO_INTERNAL_TABLE` for Excel data import, then loop through rows/columns to parse into structured internal tables.

### Template Download Pattern
Store Excel templates in SAP Web Repository (SMW0), download using `DOWNLOAD_WEB_OBJECT` with `CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG`.

## Common BAPIs in This Project

| BAPI | Purpose |
|------|---------|
| `BAPI_USER_CREATE1` | Create SAP user |
| `ISAI_USER_ROLES_MAINTAIN` | Assign roles to user |
| `BAPI_TRANSACTION_COMMIT` | Commit BAPI transaction |
| `BAPI_TRANSACTION_ROLLBACK` | Rollback BAPI transaction |
| `ALSM_EXCEL_TO_INTERNAL_TABLE` | Import Excel to internal table |
| `REUSE_ALV_GRID_DISPLAY` | Display ALV grid |
| `F4_FILENAME` | File selection dialog |
| `DOWNLOAD_WEB_OBJECT` | Download SAP Web Repository object |

## Code Review Checklist

- [ ] Program name follows Z/Y prefix convention
- [ ] File header is complete with description and modification log
- [ ] BAPI calls have proper commit/rollback handling
- [ ] Error messages use defined message class (not hardcoded strings where possible)
- [ ] Selection screen has proper validation in `AT SELECTION-SCREEN`
- [ ] ALV field catalog covers all display fields
- [ ] SY-SUBRC is checked after function module calls
- [ ] Internal tables are sorted before `READ TABLE ... BINARY SEARCH`
- [ ] No obsolete language elements (use `LIKE LINE OF` instead of header lines where practical)

## Additional Resources

- For detailed BAPI reference and parameter documentation, see [bapi-reference.md](bapi-reference.md)
