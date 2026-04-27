*&---------------------------------------------------------------------*
*& Report  ZBC001                                                     *
*&---------------------------------------------------------------------*
*& Author              :                                               *
*& Create Date         : YYYY/MM/DD                                    *
*& Description         : 系统管理-权限管理-用户角色分配程序              *
*&                       说明                                          *
*& <Function Spec      :                                               *
*& Modifications       :                                               *
*&   Date        Programmer   <需求说明号>    Description               *
*&   YYYY/MM/DD  修改人员名   <xxxxx>         说明                      *
*&---------------------------------------------------------------------*

REPORT  ZBC001 MESSAGE-ID ZBC.
TABLES: SSCRFIELDS.
TYPE-POOLS: TRUXS,
            SLIS,
            ICON.
*----------------------------------------------------------------------*
* MACRO
*----------------------------------------------------------------------*
DEFINE MCR_ALV.
  it_fieldcat-fieldname = &1.
  it_fieldcat-seltext_l = &2.
  it_fieldcat-seltext_m = &2.
  it_fieldcat-seltext_s = &2.
  it_fieldcat-col_pos   = &3.
  it_fieldcat-outputlen = &4.
  it_fieldcat-just      = &5.
  it_fieldcat-icon      = &6.
  APPEND it_fieldcat .
  CLEAR it_fieldcat .
END-OF-DEFINITION.
*----------------------------------------------------------------------*
* Constant Declaration
*----------------------------------------------------------------------*
CONSTANTS:
  C_PF_STATUS    TYPE SLIS_FORMNAME VALUE 'ALV_PF_STATUS',
  C_USER_COMMAND TYPE SLIS_FORMNAME VALUE 'ALV_USER_COMMAND'.
*----------------------------------------------------------------------*
* Type Declaration
*----------------------------------------------------------------------*
TYPES: BEGIN OF IA_USER,
         USERNAME   TYPE BAPIBNAME-BAPIBNAME,
         USTYP      TYPE BAPILOGOND-USTYP,
         CLASS      TYPE BAPILOGOND-CLASS,
         PASSWORD   TYPE BAPIPWD-BAPIPWD,
*        pers_no TYPE bapiaddr3-pers_no,
*        addr_no TYPE bapiaddr3-addr_no,
         TITLE_P    TYPE BAPIADDR3-TITLE_P,
         FIRSTNAME  TYPE BAPIADDR3-FIRSTNAME,
         LASTNAME   TYPE BAPIADDR3-LASTNAME,
         DEPARTMENT TYPE BAPIADDR3-DEPARTMENT,
         TEL1_NUMBR TYPE BAPIADDR3-TEL1_NUMBR,
         E_MAIL     TYPE BAPIADDR3-E_MAIL,
         CITY       TYPE BAPIADDR3-CITY,
         SORT1      TYPE BAPIADDR3-SORT1, "VALUE 'ANTA',
         SPLD       TYPE BAPIDEFAUL-SPLD, " VALUE 'LP01',
         DCPFM      TYPE BAPIDEFAUL-DCPFM,
         DATFM      TYPE BAPIDEFAUL-DATFM,
       END OF IA_USER.
TYPES: BEGIN OF IA_RESULT,
         USERID   TYPE BAPIBNAME-BAPIBNAME,
         USERNAME TYPE BAPIADDR3-LASTNAME,
         FLG_USER TYPE ICON_D,
         MSG_USER TYPE STRING,
         FLG_ROLE TYPE ICON_D,
         MSG_ROLE TYPE STRING,
         SEL(1)   TYPE C,
       END OF IA_RESULT.
TYPES: BEGIN OF IA_ROLE,
         USERNAME TYPE BAPIBNAME-BAPIBNAME,
         AGR_NAME TYPE BAPIAGR-AGR_NAME,
       END OF IA_ROLE.
*----------------------------------------------------------------------*
* Internal Table Declaration
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Data Declaration
*----------------------------------------------------------------------*
DATA: IT_RAW TYPE TRUXS_T_TEXT_DATA.
DATA: WT_USER TYPE STANDARD TABLE OF IA_USER,
      LS_USER LIKE LINE OF WT_USER.
DATA WT_RESULT TYPE STANDARD TABLE OF IA_RESULT.
DATA WT_ROLE TYPE STANDARD TABLE OF IA_ROLE WITH HEADER LINE.
DATA IT_FIELDCAT TYPE TABLE OF SLIS_FIELDCAT_ALV WITH HEADER LINE.
DATA WA_LAYOUT   TYPE SLIS_LAYOUT_ALV.
DATA FUNCTXT   TYPE SMP_DYNTXT.
*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
PARAMETER: P_FILE TYPE RLGRAP-FILENAME,
           P_COL  TYPE I DEFAULT 1 NO-DISPLAY,
           P_ROW  TYPE I DEFAULT 3 NO-DISPLAY.
PARAMETER: P_USER TYPE C AS CHECKBOX DEFAULT 'X',
           P_ROLE TYPE C AS CHECKBOX DEFAULT 'X',
           P_ROLE_C TYPE C AS CHECKBOX.
SELECTION-SCREEN: FUNCTION KEY 1."在屏幕定义功能码
SELECTION-SCREEN: FUNCTION KEY 2."在屏幕定义功能码
*&---------------------------------------------------------------------*
*&      INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.
  FUNCTXT-ICON_ID   = ICON_EXPORT.
  FUNCTXT-QUICKINFO = '下载横向模板'.
  FUNCTXT-ICON_TEXT = '下载横向模板'.
  SSCRFIELDS-FUNCTXT_01 = FUNCTXT.

  FUNCTXT-ICON_ID   = ICON_EXPORT.
  FUNCTXT-QUICKINFO = '下载纵向模板'.
  FUNCTXT-ICON_TEXT = '下载纵向模板'.
  SSCRFIELDS-FUNCTXT_02 = FUNCTXT.
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN OUTPUT Event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-NAME = 'P_COL' OR SCREEN-NAME = 'P_ROW'.
      SCREEN-INPUT = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
*----------------------------------------------------------------------*
* At Selection-Screen Event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      FIELD_NAME = 'P_FILE'
    IMPORTING
      FILE_NAME  = P_FILE.
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF P_USER IS INITIAL AND P_ROLE IS INITIAL AND P_ROLE_C IS INITIAL.
    MESSAGE  '请选中相应功能的复选框！' TYPE 'E'.
  ENDIF.

  IF ( P_USER IS NOT INITIAL OR P_ROLE IS NOT INITIAL ) AND P_ROLE_C IS NOT INITIAL.
    MESSAGE '纵向模板与横向模板两种模式只能二选一！' TYPE 'E'.
  ENDIF.

  CASE SSCRFIELDS-UCOMM.
*   系统预留的功能码
    WHEN 'FC01'.
      "下载模板文件
      PERFORM DOWNLOAD_EXCEL USING '1'.
    WHEN 'FC02'.
      "下载模板文件
      PERFORM DOWNLOAD_EXCEL USING '2'.
    WHEN OTHERS.
  ENDCASE.
*----------------------------------------------------------------------*
* Start-Of-Selection Event
*----------------------------------------------------------------------*
START-OF-SELECTION.

  IF P_FILE IS INITIAL.
    MESSAGE '请输入文件路径' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  DATA : IT_FILE  LIKE ALSMEX_TABLINE OCCURS 0 WITH HEADER LINE.
  IF P_ROLE_C = 'X'.
    P_COL = 2.
    P_ROW = 3.
  ENDIF.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME                = P_FILE
      I_BEGIN_COL             = P_COL
      I_BEGIN_ROW             = P_ROW
      I_END_COL               = '2560'
      I_END_ROW               = '2560'
    TABLES
      INTERN                  = IT_FILE[]
    EXCEPTIONS
      INCONSISTENT_PARAMETERS = 1
      UPLOAD_OLE              = 2
      OTHERS                  = 3.

* 抽取并整理数据
  PERFORM GET_DATA.

* 创建用户
  IF P_USER IS NOT INITIAL.
    PERFORM CREATE_USER.
  ENDIF.
* 给用户分配角色
  IF P_ROLE IS NOT INITIAL OR P_ROLE_C IS NOT INITIAL.
    PERFORM ADD_ROLE.
  ENDIF.
*  ENDIF.


*----------------------------------------------------------------------*
* End-Of-Selection Event
*----------------------------------------------------------------------*
END-OF-SELECTION.
  IF WT_USER[] IS NOT INITIAL.
    PERFORM RESULT_DISPLAY.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  CREATE_USER
*&---------------------------------------------------------------------*
FORM CREATE_USER .
  DATA: LS_USER   LIKE LINE OF WT_USER,
        LS_RESULT LIKE LINE OF WT_RESULT.
  DATA: L_USERNAME  TYPE BAPIBNAME-BAPIBNAME,
        L_LOGONDATA TYPE BAPILOGOND,
        L_PASSWORD  TYPE BAPIPWD,
        L_ADDRESS   TYPE BAPIADDR3,
        L_DEFAULTS  TYPE BAPIDEFAUL,
        LT_RETURN   TYPE STANDARD TABLE OF BAPIRET2 WITH HEADER LINE.
  LOOP AT WT_USER INTO LS_USER.
    CLEAR: L_USERNAME,
           L_LOGONDATA,
           L_PASSWORD,
           L_ADDRESS,
           L_DEFAULTS,
           LT_RETURN.
    REFRESH LT_RETURN.

    L_USERNAME = LS_USER-USERNAME.
    L_LOGONDATA-USTYP = 'A'.
    L_PASSWORD = 'Init1234'.
    L_ADDRESS-TITLE_P     = LS_USER-TITLE_P.
    L_ADDRESS-FIRSTNAME   = LS_USER-FIRSTNAME.
    L_ADDRESS-LASTNAME    = LS_USER-LASTNAME.
    L_ADDRESS-DEPARTMENT  = LS_USER-DEPARTMENT.
    L_ADDRESS-TEL1_NUMBR  = LS_USER-TEL1_NUMBR.
    L_ADDRESS-E_MAIL      = LS_USER-E_MAIL.
    L_ADDRESS-CITY        = LS_USER-CITY.
    L_DEFAULTS-SPLD       = LS_USER-SPLD.
    L_DEFAULTS-DCPFM      = LS_USER-DCPFM.
    L_DEFAULTS-DATFM      = LS_USER-DATFM.

    CALL FUNCTION 'BAPI_USER_CREATE1'
      EXPORTING
        USERNAME  = L_USERNAME
*       NAME_IN   =
        LOGONDATA = L_LOGONDATA
        PASSWORD  = L_PASSWORD
        DEFAULTS  = L_DEFAULTS
        ADDRESS   = L_ADDRESS
      TABLES
        RETURN    = LT_RETURN.
    LS_RESULT-USERNAME = LS_USER-LASTNAME.
    LS_RESULT-USERID   = LS_USER-USERNAME.              .
    READ TABLE LT_RETURN INDEX 1.
    IF LT_RETURN-TYPE = 'S'.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          WAIT = 'X'.
      LS_RESULT-FLG_USER = '@08@'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      LS_RESULT-FLG_USER = '@0A@'.
    ENDIF.
    LS_RESULT-MSG_USER = LT_RETURN-MESSAGE.
    APPEND LS_RESULT TO WT_RESULT.
  ENDLOOP.

ENDFORM.                    " CREATE_USER
*&---------------------------------------------------------------------*
*&      Form  ADD_ROLE
*&---------------------------------------------------------------------*
FORM ADD_ROLE .

  DATA: LS_USER    LIKE LINE OF WT_USER,
        LS_ROLE    LIKE LINE OF WT_ROLE,
        LS_RESULT  LIKE LINE OF WT_RESULT,
        L_FLG_ROLE LIKE LS_RESULT-FLG_ROLE.

  DATA: LT_ACTGROUPS_NEW TYPE STANDARD TABLE OF BAPIAGR WITH HEADER LINE,
        LT_RETURN        TYPE STANDARD TABLE OF BAPIRET2 WITH HEADER LINE,
        L_RETURN_STATUS  TYPE BAPI_MTYPE.
  DATA LT_TEXT TYPE STANDARD TABLE OF STRING WITH HEADER LINE.

  LOOP AT WT_USER INTO LS_USER.
    CLEAR: LS_RESULT.
    REFRESH LT_ACTGROUPS_NEW.
    LOOP AT WT_ROLE INTO LS_ROLE WHERE USERNAME = LS_USER-USERNAME.
      LT_ACTGROUPS_NEW-AGR_NAME = LS_ROLE-AGR_NAME.
      APPEND LT_ACTGROUPS_NEW.
    ENDLOOP.


    CALL FUNCTION 'ISAI_USER_ROLES_MAINTAIN'
      EXPORTING
        USERNAME      = LS_USER-USERNAME
      IMPORTING
        RETURN_STATUS = L_RETURN_STATUS
      TABLES
        ACTGROUPS_NEW = LT_ACTGROUPS_NEW
        RETURN        = LT_RETURN.

    READ TABLE LT_RETURN INDEX 1.

    IF L_RETURN_STATUS = 'E' OR  L_RETURN_STATUS = 'A'.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      L_FLG_ROLE = '@0A@'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          WAIT = 'X'.
      L_FLG_ROLE = '@08@'.
    ENDIF.

    READ TABLE WT_RESULT INTO LS_RESULT WITH KEY USERID = LS_USER-USERNAME.
    IF SY-SUBRC <> 0.
      LS_RESULT-USERNAME = LS_USER-LASTNAME.
      LS_RESULT-USERID   = LS_USER-USERNAME.
      LS_RESULT-FLG_ROLE = L_FLG_ROLE.
      LS_RESULT-MSG_ROLE = LT_RETURN-MESSAGE.
      APPEND LS_RESULT TO WT_RESULT.
    ELSE.
      LS_RESULT-FLG_ROLE = L_FLG_ROLE.
      LS_RESULT-MSG_ROLE = LT_RETURN-MESSAGE.
      MODIFY WT_RESULT[] INDEX SY-TABIX FROM LS_RESULT.
    ENDIF.
    CLEAR: L_FLG_ROLE,
           LS_RESULT.
  ENDLOOP.

ENDFORM.                    " ADD_ROLE
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*

FORM GET_DATA .
  DATA: BEGIN OF LT_AGR_DEFINE OCCURS 0,
          AGR_NAME TYPE AGR_DEFINE-AGR_NAME,
        END OF LT_AGR_DEFINE.
  DATA: BEGIN OF LT_CLASS OCCURS 0,
          USERGROUP TYPE USGRP-USERGROUP,
        END OF LT_CLASS.
  DATA: BEGIN OF LA_ROLE OCCURS 0,
          INDEX    TYPE KCD_EX_COL_N,
          ROLENAME LIKE  AGR_DEFINE-AGR_NAME,
          TEXT     LIKE  AGR_TEXTS-TEXT,
          FLAG     TYPE C,
        END OF LA_ROLE.

  DATA: BEGIN OF LA_USER OCCURS 0,
          INDEX    TYPE KCD_EX_COL_N,
          USERNAME TYPE BAPIBNAME-BAPIBNAME,
        END OF LA_USER.
  DATA: BEGIN OF LT_USER OCCURS 0,
          BNAME TYPE USR21-BNAME,
        END OF LT_USER.

  SELECT AGR_NAME FROM AGR_DEFINE INTO CORRESPONDING FIELDS OF TABLE LT_AGR_DEFINE.
  SORT LT_AGR_DEFINE.

  SELECT USERGROUP FROM USGRP INTO CORRESPONDING FIELDS OF TABLE LT_CLASS.
  SORT LT_CLASS.

  SELECT BNAME FROM USR21 INTO TABLE LT_USER .
  SORT LT_USER.

  DATA LS_ROLE LIKE LINE OF LA_ROLE.
  REFRESH WT_USER.
  IF NOT P_ROLE_C IS INITIAL.  "纵向导入，注意：需要用户已创建
    LOOP AT IT_FILE.
      IF IT_FILE-ROW = '0001' AND IT_FILE-VALUE IS NOT INITIAL.
        TRANSLATE IT_FILE-VALUE TO UPPER CASE.
*        READ TABLE lt_user WITH KEY bname = it_file-value BINARY SEARCH.
*        IF sy-subrc NE 0.
*          MESSAGE s001(00) DISPLAY LIKE 'E' WITH '该用户不存在：' it_file-value.
*          STOP.
*        ELSE.
        LA_USER-USERNAME = IT_FILE-VALUE.
        LA_USER-INDEX = IT_FILE-COL.
        APPEND LA_USER.
        CLEAR:LA_USER.
        LS_USER-USERNAME = IT_FILE-VALUE.
        APPEND LS_USER TO WT_USER.
        CLEAR:LS_USER.
*        ENDIF.
      ENDIF.
    ENDLOOP.
    LOOP AT LA_USER.
      LOOP AT IT_FILE WHERE ROW > '0002'
                        AND COL = LA_USER-INDEX.
        TRANSLATE IT_FILE-VALUE TO UPPER CASE.
*        READ TABLE lt_agr_define WITH KEY agr_name = it_file-value BINARY SEARCH.
*        IF sy-subrc <> 0.
*          MESSAGE s001(00) DISPLAY LIKE 'E' WITH '该角色不存在：' it_file-value.
*          STOP.
*        ELSE..
        WT_ROLE-USERNAME = LA_USER-USERNAME.
        WT_ROLE-AGR_NAME = IT_FILE-VALUE.
        APPEND WT_ROLE.
        CLEAR:WT_ROLE.
*        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ELSE.    "横向导入
    LOOP AT IT_FILE.
      IF IT_FILE-ROW = '0003' AND IT_FILE-COL > '0019' AND P_ROLE IS NOT INITIAL.
        TRANSLATE IT_FILE-VALUE TO UPPER CASE.
        READ TABLE LT_AGR_DEFINE WITH KEY AGR_NAME = IT_FILE-VALUE BINARY SEARCH.
        IF SY-SUBRC <> 0.
          MESSAGE S001 DISPLAY LIKE 'E' WITH IT_FILE-VALUE.
          STOP.
        ENDIF.
        LS_ROLE-INDEX = IT_FILE-COL.
        LS_ROLE-ROLENAME = IT_FILE-VALUE.
        APPEND LS_ROLE TO LA_ROLE.
      ENDIF.

      IF IT_FILE-ROW > '0004' AND IT_FILE-COL < '0019'.
        CASE IT_FILE-COL.
          WHEN '0001'.
            LS_USER-LASTNAME = IT_FILE-VALUE.
          WHEN '0003'.
            LS_USER-USERNAME = IT_FILE-VALUE.
            WT_ROLE-USERNAME = IT_FILE-VALUE.
          WHEN '0004'.
            LS_USER-TITLE_P = IT_FILE-VALUE.
          WHEN '0005'.
            LS_USER-CITY = IT_FILE-VALUE.
          WHEN '0007'.
            LS_USER-DEPARTMENT = IT_FILE-VALUE.
          WHEN '0009'.
            LS_USER-TEL1_NUMBR = IT_FILE-VALUE.
          WHEN '0010'.
            LS_USER-E_MAIL = IT_FILE-VALUE.
          WHEN '0011'.
            LS_USER-USTYP = 'A'.
          WHEN '0012'.
            LS_USER-SPLD = IT_FILE-VALUE.
          WHEN '0013'.
            LS_USER-DATFM = IT_FILE-VALUE.
          WHEN '0014'.
            LS_USER-DCPFM = IT_FILE-VALUE.
          WHEN '0018'.
            LS_USER-CLASS = IT_FILE-VALUE.
            READ TABLE LT_CLASS WITH KEY USERGROUP = LS_USER-CLASS BINARY SEARCH.
            IF SY-SUBRC <> 0.
              MESSAGE S012 DISPLAY LIKE 'E' WITH IT_FILE-VALUE.
              STOP.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ELSEIF IT_FILE-ROW > '0004' AND IT_FILE-COL > '0019' AND IT_FILE-VALUE = 'X'.
        READ TABLE LA_ROLE WITH KEY INDEX = IT_FILE-COL.
        IF SY-SUBRC = 0.
          WT_ROLE-AGR_NAME = LA_ROLE-ROLENAME.
          APPEND WT_ROLE.
        ENDIF.
      ENDIF.

      AT END OF ROW.
        IF  IT_FILE-ROW < 5.
          CONTINUE.
        ENDIF.
        APPEND LS_USER TO WT_USER.
        CLEAR LS_USER.
      ENDAT.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  RESULT_DISPLAY
*&---------------------------------------------------------------------*
FORM RESULT_DISPLAY .
*&Prepare ALV Fields .
  PERFORM SET_ALV_FIELDS.

*&Set ALV Layout
  PERFORM GET_ALV_LAYOUT.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      I_CALLBACK_PF_STATUS_SET = C_PF_STATUS
      I_CALLBACK_USER_COMMAND  = C_USER_COMMAND
      IS_LAYOUT                = WA_LAYOUT
      I_SAVE                   = 'A'
      IT_FIELDCAT              = IT_FIELDCAT[]
    TABLES
      T_OUTTAB                 = WT_RESULT
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.
ENDFORM.                    " RESULT_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  ALV_PF_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM ALV_PF_STATUS USING  RT_EXTAB TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'ZBC001'.
ENDFORM.                    " alv_pf_status
*&---------------------------------------------------------------------*
*&      Form  ALV_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM ALV_USER_COMMAND USING P_UCOMM LIKE SY-UCOMM
                            P_SELFIELD TYPE SLIS_SELFIELD.
  DATA LS_RESULT LIKE LINE OF WT_RESULT.
  CASE P_UCOMM.
    WHEN '&IC1'.
      READ TABLE WT_RESULT INTO LS_RESULT INDEX P_SELFIELD-TABINDEX.
      SET PARAMETER ID 'XUS' FIELD LS_RESULT-USERID.
      CALL TRANSACTION 'SU01' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " alv_USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  GET_ALV_LAYOUT
*&---------------------------------------------------------------------*
FORM GET_ALV_LAYOUT .
  CLEAR: WA_LAYOUT.
  WA_LAYOUT-COLWIDTH_OPTIMIZE   = 'X' .        "Optimize field width
  WA_LAYOUT-BOX_FIELDNAME       = 'SEL'.       " Checkbox
ENDFORM.                    " GET_ALV_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  SET_ALV_FIELDS
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDS .
  MCR_ALV 'USERNAME'  '用户名'       '1' '' '' ''.
  MCR_ALV 'USERID'    '用户ID'         '2' '' '' ''.
  IF P_USER IS NOT INITIAL.
    MCR_ALV 'FLG_USER'  '用户标识'   '3' '' '' 'X'.
    MCR_ALV 'MSG_USER'  '用户创建信息'   '4' '' '' ''.
  ENDIF.
  IF P_ROLE IS NOT INITIAL.
    MCR_ALV 'FLG_ROLE'  '角色标识'   '5' '' '' 'X'.
    MCR_ALV 'MSG_ROLE'  '角色分配信息'   '6' '' '' ''.
  ENDIF.
ENDFORM.                    " SET_ALV_FIELDS
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD_EXCEL  USING P_TYPE.

  DATA:
    L_FULLPATH TYPE STRING,
    L_PATH     TYPE STRING,
    L_NAME     TYPE STRING.

* 用户选择保存路径
  PERFORM FRM_GET_FULLPATH CHANGING L_FULLPATH L_PATH L_NAME P_TYPE.
* 路径为空则退出
  IF L_FULLPATH IS INITIAL.
    MESSAGE '用户取消操作' TYPE 'S'.
    RETURN.
  ENDIF.

* 下载模板
  PERFORM FRM_DOWNLOAD_EXCEL_FROM_SERVER USING L_FULLPATH P_TYPE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FRM_GET_FULLPATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_FULLPATH  text
*      <--P_L_PATH  text
*      <--P_L_NAME  text
*----------------------------------------------------------------------*
FORM FRM_GET_FULLPATH CHANGING P_FULLPATH
                               P_PATH
                               P_NAME
                               P_TYPE.
  DATA:
    LV_INIT_PATH  TYPE STRING,
    LV_INIT_FNAME TYPE STRING,
    LV_PATH       TYPE STRING,
    LV_FILENAME   TYPE STRING,
    LV_FULLPATH   TYPE STRING.

* 初始名称(输出的文件名称)

  CASE P_TYPE.
    WHEN '1'.
      LV_INIT_FNAME = '1横向模板创建用户&添加角色' && SY-DATUM.
    WHEN '2'.
      LV_INIT_FNAME = '2纵向模板添加角色' && SY-DATUM.
  ENDCASE.

* 获取桌面路径
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>GET_DESKTOP_DIRECTORY
    CHANGING
      DESKTOP_DIRECTORY    = LV_INIT_PATH
    EXCEPTIONS
      CNTL_ERROR           = 1
      ERROR_NO_GUI         = 2
      NOT_SUPPORTED_BY_GUI = 3
      OTHERS               = 4.
  IF SY-SUBRC <> 0.
    EXIT.
  ENDIF.

* 用户选择名称、路径
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      DEFAULT_EXTENSION    = 'XLSX'
      DEFAULT_FILE_NAME    = LV_INIT_FNAME
      FILE_FILTER          = CL_GUI_FRONTEND_SERVICES=>FILETYPE_ALL
      INITIAL_DIRECTORY    = LV_INIT_PATH
      PROMPT_ON_OVERWRITE  = 'X'
    CHANGING
      FILENAME             = LV_FILENAME
      PATH                 = LV_PATH
      FULLPATH             = LV_FULLPATH
    EXCEPTIONS
      CNTL_ERROR           = 1
      ERROR_NO_GUI         = 2
      NOT_SUPPORTED_BY_GUI = 3
      OTHERS               = 4.
  IF SY-SUBRC = 0.
    P_FULLPATH = LV_FULLPATH.
    P_PATH     = LV_PATH.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FRM_DOWNLOAD_EXCEL_FROM_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_L_FULLPATH  text
*----------------------------------------------------------------------*
FORM FRM_DOWNLOAD_EXCEL_FROM_SERVER USING P_FILENAME P_TYPE.

  DATA:
    LV_OBJDATA     LIKE WWWDATATAB,
    LV_DESTINATION LIKE RLGRAP-FILENAME,
    LV_RC          LIKE SY-SUBRC,
    LV_ERRTXT      TYPE STRING.

  DATA:
    LV_FILENAME TYPE STRING,
    LV_RESULT,
    LV_SUBRC    TYPE SY-SUBRC,
    LV_OBJID    TYPE WWWDATATAB-OBJID.

  LV_OBJID = 'ZBC001_'  && P_TYPE.

  "查找文件是否存在。
  SELECT SINGLE RELID OBJID
     FROM WWWDATA
     INTO CORRESPONDING FIELDS OF LV_OBJDATA
     WHERE SRTF2    = 0
     AND   RELID    = 'MI'
     AND   OBJID    = LV_OBJID.

  "判断模版不存在则报错
  IF SY-SUBRC NE 0 OR LV_OBJDATA-OBJID EQ SPACE.
    CONCATENATE '模板文件：' LV_OBJID '不存在，请用TCODE：SMW0进行加载'
    INTO LV_ERRTXT.
    MESSAGE E000(SU) WITH LV_ERRTXT.
  ENDIF.

  LV_FILENAME = P_FILENAME.

  "判断本地地址是否已经存在此文件。
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_EXIST
    EXPORTING
      FILE                 = LV_FILENAME
    RECEIVING
      RESULT               = LV_RESULT
    EXCEPTIONS
      CNTL_ERROR           = 1
      ERROR_NO_GUI         = 2
      WRONG_PARAMETER      = 3
      NOT_SUPPORTED_BY_GUI = 4
      OTHERS               = 5.
  IF LV_RESULT EQ 'X'.                                                  "如果存在则删除原始文件，重新覆盖
    CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_DELETE
      EXPORTING
        FILENAME             = LV_FILENAME
      CHANGING
        RC                   = LV_SUBRC
      EXCEPTIONS
        FILE_DELETE_FAILED   = 1
        CNTL_ERROR           = 2
        ERROR_NO_GUI         = 3
        FILE_NOT_FOUND       = 4
        ACCESS_DENIED        = 5
        UNKNOWN_ERROR        = 6
        NOT_SUPPORTED_BY_GUI = 7
        WRONG_PARAMETER      = 8
        OTHERS               = 9.
    IF LV_SUBRC <> 0. "如果删除失败，则报错。
      CONCATENATE '同名EXCEL文件已打开' '请关闭该EXCEL后重试。'
       INTO LV_ERRTXT.
      MESSAGE E000(SU) WITH LV_ERRTXT.
    ENDIF.
  ENDIF.

  LV_DESTINATION   = P_FILENAME.

  "下载模版。
  CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
    EXPORTING
      KEY         = LV_OBJDATA
      DESTINATION = LV_DESTINATION
    IMPORTING
      RC          = LV_RC.
  IF LV_RC NE 0.
    CONCATENATE '模板文件' '下载失败' INTO LV_ERRTXT.
    MESSAGE E000(SU) WITH LV_ERRTXT.
  ELSE.
    P_FILE = LV_FILENAME.
  ENDIF.

ENDFORM.
