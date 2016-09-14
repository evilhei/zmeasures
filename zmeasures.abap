*&---------------------------------------------------------------------*
*& Report  ZMEASURES
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZMEASURES.

TABLES: mchb, mska, makt, mara.

DATA:
numtab TYPE TABLE OF bapi1003_alloc_values_num WITH HEADER LINE,
chatab TYPE TABLE OF bapi1003_alloc_values_char WITH HEADER LINE,
curtab TYPE TABLE OF     bapi1003_alloc_values_curr WITH HEADER LINE,
rettab TYPE table of BAPIRET2,
i_return TYPE bapiret2,
      lv_16spaces TYPE string VALUE '                ',
      lv_15spaces TYPE string VALUE '               ',
      lv_12spaces TYPE string VALUE '            ',
      lv_8spaces TYPE string VALUE '        ',
      lv_9spaces TYPE string VALUE '         ',
      lv_10spaces TYPE string VALUE '         '.

DATA: lv_objkey(50) TYPE c,
      lv_matnr type mchb-matnr,
      lv_charg type mchb-charg.
DATA: itab type standard table of bapi1003_alloc_values_num WITH HEADER LINE,
        meinh type string,
        itab2 TYPE STANDARD TABLE OF string.

DATA: i_mchb TYPE mchb occurs 0 with header line,
      i_mska TYPE mska occurs 0 with header line.

TYPES: BEGIN OF ty_measures,
matnr type mchb-matnr,
charg type mchb-charg,
werks type mchb-werks,
werks1 TYPE mska-werks,
kalab type mska-kalab,
clabs type mchb-clabs,
maktx type makt-maktx,
lgort type mchb-lgort,
Length_01	TYPE i ,
Width_01  TYPE i,
Height_01	TYPE i,
Weight_01	TYPE i,
Length_02	TYPE i,
Width_02  TYPE i,
Height_02	TYPE i,
Weight_02	TYPE i,
Length_03	TYPE i,
Width_03  TYPE i,
Height_03	TYPE i,
Weight_03	TYPE i,
Length_04	TYPE i,
Width_04  TYPE i,
Height_04	TYPE i,
Weight_04	TYPE i,
Length_05	TYPE i,
Width_05  TYPE i,
Height_05	TYPE i,
Weight_05	TYPE i,
Length_06	TYPE i,
Width_06  TYPE i,
Height_06	TYPE i,
Weight_06	TYPE i,
Length_07	TYPE i,
Width_07  TYPE i,
Height_07	TYPE i,
Weight_07	TYPE i,
Length_08	TYPE i,
Width_08  TYPE i,
Height_08	TYPE i,
Weight_08	TYPE i,
Length_09	TYPE i,
Width_09  TYPE i,
Height_09	TYPE i,
Weight_09	TYPE i,
cell_color TYPE lvc_t_scol,
END OF ty_measures.

DATA: t_measures TYPE ty_measures OCCURS 0 WITH HEADER LINE,
      wa_measures TYPE ty_measures.

DATA: t_layout TYPE slis_layout_alv,
      t_fieldcatelog TYPE slis_t_fieldcat_alv,
      t_listheader TYPE slis_t_listheader,
      t_events TYPE slis_t_event,
      t_sortinfo TYPE slis_t_sortinfo_alv.
DATA: ls_cellcolor TYPE lvc_s_scol.

DATA: v_repid LIKE sy-repid.

DATA:
  pa_matnr TYPE mara-matnr,
  pa_charg TYPE mcha-charg.

SELECTION-SCREEN BEGIN OF BLOCK selection WITH FRAME.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text-002 FOR FIELD p_matnr.
SELECTION-SCREEN POSITION 25.
SELECT-OPTIONS : p_matnr FOR pa_matnr.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text-004 FOR FIELD p_charg.
SELECTION-SCREEN POSITION 25.
SELECT-OPTIONS : p_charg FOR pa_charg.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text-001 FOR FIELD pa_werks.
SELECTION-SCREEN POSITION 25.
PARAMETERS: pa_werks like mchb-werks.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK selection.


AT SELECTION-SCREEN OUTPUT.
  MODIFY SCREEN.

INITIALIZATION.
  v_repid = sy-repid.



END-OF-SELECTION.
  PERFORM build_outputdata.
  PERFORM build_fieldcatelog.
  PERFORM build_eventsinfo.
  PERFORM build_sortinfo.
  PERFORM build_listheader.
  PERFORM build_layout USING t_layout.

  PERFORM display_gridreport.

FORM build_outputdata.

  SELECT * into i_mchb from mchb WHERE
    matnr in p_matnr AND
    charg in p_charg.
  APPEND i_mchb.
  CLEAR i_mchb.
  ENDSELECT.

  SELECT * into i_mska from mska WHERE
    matnr in p_matnr AND
    charg in p_charg.
  APPEND i_mska.
  CLEAR i_mska.
  ENDSELECT.

  LOOP AT i_mchb.
  SELECT maktx INTO CORRESPONDING FIELDS OF wa_measures
    FROM makt
    WHERE matnr = i_mchb-matnr AND
    spras = sy-langu.
    ENDSELECT.

  SELECT
    matnr
    charg
    werks
    clabs
    LGORT
    INTO CORRESPONDING FIELDS OF wa_measures
    FROM  mchb
    WHERE matnr = i_mchb-matnr AND
          charg = i_mchb-charg.
    ENDSELECT.

    lv_matnr = i_mchb-matnr.
    lv_charg = i_mchb-charg.

CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = lv_matnr
    IMPORTING
      output = lv_matnr.


IF STRLEN( lv_matnr ) = 3.
  CONCATENATE lv_matnr lv_15spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 2.
  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 6.
  CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 10.
  CONCATENATE lv_matnr lv_8spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 8.
  CONCATENATE lv_matnr lv_10spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 7.
  CONCATENATE lv_matnr lv_9spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSE.
  CONCATENATE lv_matnr lv_charg INTO lv_objkey.
ENDIF.

*IF lv_matnr = 'SH1'.
*  CONCATENATE lv_matnr lv_15spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SP'.
*  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SH'.
*  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SPP'.
*  CONCATENATE lv_matnr lv_15spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SPP_BH'.
* CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SPP_NH'.
*  CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = ''.
*  CONCATENATE lv_matnr '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SP'.
*  CONCATENATE lv_matnr lv_16spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SPP'.
*  CONCATENATE lv_matnr lv_15spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SH'.
*  CONCATENATE lv_matnr lv_16spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SPP_BH'.
*  CONCATENATE lv_matnr lv_12spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SPP_NH'.
*  CONCATENATE lv_matnr lv_12spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSE.
*CONCATENATE lv_matnr lv_charg INTO lv_objkey.
*ENDIF.
field-symbols:
        <fs> like line of itab.
      CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
           EXPORTING
                objectkey        = lv_objkey
                objecttable      = 'MCH1'
                classnum         = 'PACK'
                classtype        = '023'
                unvaluated_chars = 'X'
           TABLES
                allocvaluesnum   = numtab
                allocvalueschar  = chatab
                allocvaluescurr  = curtab
                return           = rettab.

LOOP AT numtab.
  CASE numtab-charact.
    WHEN 'WIDTH_01'.
      wa_measures-width_01 = numtab-value_from.
      ls_cellcolor-fname = 'Width_01'.
      ls_cellcolor-color-col = '1'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'HEIGHT_01'.
      wa_measures-height_01 = numtab-value_from.
      ls_cellcolor-fname = 'Height_01'.
      ls_cellcolor-color-col = '1'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'LENGTH_01'.
      wa_measures-length_01 = numtab-value_from.
      ls_cellcolor-fname = 'Length_01'.
      ls_cellcolor-color-col = '1'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'WEIGHT_01'.
      wa_measures-weight_01 = numtab-value_from.
      ls_cellcolor-fname = 'Weight_01'.
      ls_cellcolor-color-col = '1'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'WIDTH_02'.
      wa_measures-width_02 = numtab-value_from.
      ls_cellcolor-fname = 'Width_02'.
      ls_cellcolor-color-col = '2'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'HEIGHT_02'.
      wa_measures-height_02 = numtab-value_from.
      ls_cellcolor-fname = 'Height_02'.
      ls_cellcolor-color-col = '2'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'LENGTH_02'.
      wa_measures-Length_02 = numtab-value_from.
      ls_cellcolor-fname = 'Length_02'.
      ls_cellcolor-color-col = '2'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'WEIGHT_02'.
      wa_measures-Weight_02 = numtab-value_from.
      ls_cellcolor-fname = 'Weight_02'.
      ls_cellcolor-color-col = '2'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'WIDTH_03'.
     wa_measures-width_03 = numtab-value_from.
      ls_cellcolor-fname = 'Width_03'.
      ls_cellcolor-color-col = '3'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'HEIGHT_03'.
      wa_measures-height_03 = numtab-value_from.
      ls_cellcolor-fname = 'Height_03'.
      ls_cellcolor-color-col = '3'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'LENGTH_03'.
      wa_measures-Length_03 = numtab-value_from.
      ls_cellcolor-fname = 'Length_03'.
      ls_cellcolor-color-col = '3'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'WEIGHT_03'.
      wa_measures-Weight_03 = numtab-value_from.
      ls_cellcolor-fname = 'Weight_03'.
      ls_cellcolor-color-col = '3'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
      APPEND ls_cellcolor TO wa_measures-cell_color.
    WHEN 'WIDTH_04'.
      wa_measures-width_04 = numtab-value_from.
      ls_cellcolor-fname = 'Width_04'.
      ls_cellcolor-color-col = '5'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
    WHEN 'HEIGHT_04'.
      wa_measures-height_04 = numtab-value_from.
      ls_cellcolor-fname = 'Height_04'.
      ls_cellcolor-color-col = '5'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
    WHEN 'LENGTH_04'.
      wa_measures-Length_04 = numtab-value_from.
      ls_cellcolor-fname = 'Length_04'.
      ls_cellcolor-color-col = '5'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
    WHEN 'WEIGHT_04'.
      wa_measures-Weight_04 = numtab-value_from.
      ls_cellcolor-fname = 'Weight_05'.
      ls_cellcolor-color-col = '5'.
      ls_cellcolor-color-int = '1'.
      ls_cellcolor-color-inv = '0'.
    WHEN 'WIDTH_05'.
      wa_measures-width_05 = numtab-value_from.
    WHEN 'HEIGHT_05'.
      wa_measures-height_05 = numtab-value_from.
    WHEN 'LENGTH_05'.
      wa_measures-Length_05 = numtab-value_from.
    WHEN 'WEIGHT_05'.
      wa_measures-Weight_05 = numtab-value_from.
    WHEN 'WIDTH_06'.
      wa_measures-width_06 = numtab-value_from.
    WHEN 'HEIGHT_06'.
      wa_measures-height_06 = numtab-value_from.
    WHEN 'LENGTH_06'.
      wa_measures-Length_06 = numtab-value_from.
    WHEN 'WEIGHT_06'.
      wa_measures-Weight_06 = numtab-value_from.
    WHEN 'WIDTH_07'.
      wa_measures-width_07 = numtab-value_from.
    WHEN 'HEIGHT_07'.
      wa_measures-height_07 = numtab-value_from.
    WHEN 'LENGTH_07'.
      wa_measures-Length_07 = numtab-value_from.
    WHEN 'WEIGHT_07'.
      wa_measures-Weight_07 = numtab-value_from.
    WHEN 'WIDTH_08'.
      wa_measures-width_08 = numtab-value_from.
    WHEN 'HEIGHT_08'.
      wa_measures-height_08 = numtab-value_from.
    WHEN 'LENGTH_08'.
      wa_measures-Length_08 = numtab-value_from.
    WHEN 'WEIGHT_08'.
      wa_measures-Weight_08 = numtab-value_from.
    WHEN 'WIDTH_09'.
      wa_measures-width_09 = numtab-value_from.
    WHEN 'HEIGHT_09'.
      wa_measures-height_09 = numtab-value_from.
    WHEN 'LENGTH_09'.
      wa_measures-Length_09 = numtab-value_from.
    WHEN 'WEIGHT_09'.
      wa_measures-Weight_09 = numtab-value_from.
  ENDCASE.
  ENDLOOP.
  APPEND wa_measures to t_measures.
  CLEAR numtab.



ENDLOOP.


CLEAR:

lv_matnr,
lv_charg.

LOOP AT i_mska.
  SELECT maktx INTO CORRESPONDING FIELDS OF wa_measures
    FROM makt
    WHERE matnr = i_mska-matnr AND
    spras = sy-langu.
    ENDSELECT.

  SELECT
    matnr
    charg
    werks
    kalab
    LGORT
    INTO CORRESPONDING FIELDS OF wa_measures
    FROM  mska
    WHERE matnr = i_mska-matnr AND
          charg = i_mska-charg.
    ENDSELECT.

    lv_matnr = i_mska-matnr.
    lv_charg = i_mska-charg.

CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = lv_matnr
    IMPORTING
      output = lv_matnr.

IF STRLEN( lv_matnr ) = 3.
  CONCATENATE lv_matnr lv_15spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 2.
  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 6.
  CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 10.
  CONCATENATE lv_matnr lv_8spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 8.
  CONCATENATE lv_matnr lv_10spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF STRLEN( lv_matnr ) = 7.
  CONCATENATE lv_matnr lv_9spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSE.
  CONCATENATE lv_matnr lv_charg INTO lv_objkey.
ENDIF.

*IF lv_matnr = 'SP'.
*  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SH'.
*  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SPP'.
*  CONCATENATE lv_matnr lv_15spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SPP_BH'.
* CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_matnr = 'SPP_NH'.
*  CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = ''.
*  CONCATENATE lv_matnr '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SP'.
*  CONCATENATE lv_matnr lv_16spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SPP'.
*  CONCATENATE lv_matnr lv_15spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SH'.
*  CONCATENATE lv_matnr lv_16spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SPP_BH'.
*  CONCATENATE lv_matnr lv_12spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSEIF lv_charg = '' AND lv_matnr = 'SPP_NH'.
*  CONCATENATE lv_matnr lv_12spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
*ELSE.
*CONCATENATE lv_matnr lv_charg INTO lv_objkey.
*ENDIF.


field-symbols:
        <fs1> like line of itab.
      CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
           EXPORTING
                objectkey        = lv_objkey
                objecttable      = 'MCH1'
                classnum         = 'PACK'
                classtype        = '023'
                unvaluated_chars = 'X'
           TABLES
                allocvaluesnum   = numtab
                allocvalueschar  = chatab
                allocvaluescurr  = curtab
                return           = rettab.

LOOP AT numtab.
  CASE numtab-charact.
    WHEN 'WIDTH_01'.
      wa_measures-width_01 = numtab-value_from.
    WHEN 'HEIGHT_01'.
      wa_measures-height_01 = numtab-value_from.
    WHEN 'LENGTH_01'.
      wa_measures-Length_01 = numtab-value_from.
    WHEN 'WEIGHT_01'.
      wa_measures-Weight_01 = numtab-value_from.
    WHEN 'WIDTH_02'.
      wa_measures-width_02 = numtab-value_from.
    WHEN 'HEIGHT_02'.
      wa_measures-height_02 = numtab-value_from.
    WHEN 'LENGTH_02'.
      wa_measures-Length_02 = numtab-value_from.
    WHEN 'WEIGHT_02'.
      wa_measures-Weight_02 = numtab-value_from.
    WHEN 'WIDTH_03'.
     wa_measures-width_03 = numtab-value_from.
    WHEN 'HEIGHT_03'.
      wa_measures-height_03 = numtab-value_from.
    WHEN 'LENGTH_03'.
      wa_measures-Length_03 = numtab-value_from.
    WHEN 'WEIGHT_03'.
      wa_measures-Weight_03 = numtab-value_from.
    WHEN 'WIDTH_04'.
      wa_measures-width_04 = numtab-value_from.
    WHEN 'HEIGHT_04'.
      wa_measures-height_04 = numtab-value_from.
    WHEN 'LENGTH_04'.
      wa_measures-Length_04 = numtab-value_from.
    WHEN 'WEIGHT_04'.
      wa_measures-Weight_04 = numtab-value_from.
    WHEN 'WIDTH_05'.
      wa_measures-width_05 = numtab-value_from.
    WHEN 'HEIGHT_05'.
      wa_measures-height_05 = numtab-value_from.
    WHEN 'LENGTH_05'.
      wa_measures-Length_05 = numtab-value_from.
    WHEN 'WEIGHT_05'.
      wa_measures-Weight_05 = numtab-value_from.
    WHEN 'WIDTH_06'.
      wa_measures-width_06 = numtab-value_from.
    WHEN 'HEIGHT_06'.
      wa_measures-height_06 = numtab-value_from.
    WHEN 'LENGTH_06'.
      wa_measures-Length_06 = numtab-value_from.
    WHEN 'WEIGHT_06'.
      wa_measures-Weight_06 = numtab-value_from.
    WHEN 'WIDTH_07'.
      wa_measures-width_07 = numtab-value_from.
    WHEN 'HEIGHT_07'.
      wa_measures-height_07 = numtab-value_from.
    WHEN 'LENGTH_07'.
      wa_measures-Length_07 = numtab-value_from.
    WHEN 'WEIGHT_07'.
      wa_measures-Weight_07 = numtab-value_from.
    WHEN 'WIDTH_08'.
      wa_measures-width_08 = numtab-value_from.
    WHEN 'HEIGHT_08'.
      wa_measures-height_08 = numtab-value_from.
    WHEN 'LENGTH_08'.
      wa_measures-Length_08 = numtab-value_from.
    WHEN 'WEIGHT_08'.
      wa_measures-Weight_08 = numtab-value_from.
    WHEN 'WIDTH_09'.
      wa_measures-width_09 = numtab-value_from.
    WHEN 'HEIGHT_09'.
      wa_measures-height_09 = numtab-value_from.
    WHEN 'LENGTH_09'.
      wa_measures-Length_09 = numtab-value_from.
    WHEN 'WEIGHT_09'.
      wa_measures-Weight_09 = numtab-value_from.
  ENDCASE.
  ENDLOOP.
  APPEND wa_measures to t_measures.
  CLEAR numtab.



ENDLOOP.


ENDFORM.

FORM get_UOM.

lv_matnr = pa_matnr.
lv_charg = pa_charg.
CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = lv_matnr
    IMPORTING
      output = lv_matnr.
IF lv_matnr = 'SP'.
  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_matnr = 'SH'.
  CONCATENATE lv_matnr lv_16spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_matnr = 'SPP'.
  CONCATENATE lv_matnr lv_15spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_matnr = 'SPP_BH'.
 CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_matnr = 'SPP_NH'.
  CONCATENATE lv_matnr lv_12spaces lv_charg INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_charg = ''.
  CONCATENATE lv_matnr '0000000000' INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_charg = '' AND lv_matnr = 'SP'.
  CONCATENATE lv_matnr lv_16spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_charg = '' AND lv_matnr = 'SPP'.
  CONCATENATE lv_matnr lv_15spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_charg = '' AND lv_matnr = 'SH'.
  CONCATENATE lv_matnr lv_16spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_charg = '' AND lv_matnr = 'SPP_BH'.
  CONCATENATE lv_matnr lv_12spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
ELSEIF lv_charg = '' AND lv_matnr = 'SPP_NH'.
  CONCATENATE lv_matnr lv_12spaces '0000000000' INTO lv_objkey RESPECTING BLANKS.
ELSE.
CONCATENATE lv_matnr lv_charg INTO lv_objkey.
ENDIF.
field-symbols:
        <fs> like line of itab.
      CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
           EXPORTING
                objectkey        = lv_objkey
                objecttable      = 'MCH1'
                classnum         = 'PACK'
                classtype        = '023'
                unvaluated_chars = 'X'
           TABLES
                allocvaluesnum   = numtab
                allocvalueschar  = chatab
                allocvaluescurr  = curtab
                return           = rettab.

LOOP AT numtab.
  CASE numtab-charact.
    WHEN 'WIDTH_01'.
      wa_measures-width_01 = numtab-value_from.
    WHEN 'HEIGHT_01'.
      wa_measures-height_01 = numtab-value_from.
    WHEN 'LENGTH_01'.
      wa_measures-Length_01 = numtab-value_from.
    WHEN 'WEIGHT_01'.
      wa_measures-Weight_01 = numtab-value_from.
    WHEN 'WIDTH_02'.
      wa_measures-width_02 = numtab-value_from.
    WHEN 'HEIGHT_02'.
      wa_measures-height_02 = numtab-value_from.
    WHEN 'LENGTH_02'.
      wa_measures-Length_02 = numtab-value_from.
    WHEN 'WEIGHT_02'.
      wa_measures-Weight_02 = numtab-value_from.
    WHEN 'WIDTH_03'.
     wa_measures-width_03 = numtab-value_from.
    WHEN 'HEIGHT_03'.
      wa_measures-height_03 = numtab-value_from.
    WHEN 'LENGTH_03'.
      wa_measures-Length_03 = numtab-value_from.
    WHEN 'WEIGHT_03'.
      wa_measures-Weight_03 = numtab-value_from.
    WHEN 'WIDTH_04'.
      wa_measures-width_04 = numtab-value_from.
    WHEN 'HEIGHT_04'.
      wa_measures-height_04 = numtab-value_from.
    WHEN 'LENGTH_04'.
      wa_measures-Length_04 = numtab-value_from.
    WHEN 'WEIGHT_04'.
      wa_measures-Weight_04 = numtab-value_from.
    WHEN 'WIDTH_05'.
      wa_measures-width_05 = numtab-value_from.
    WHEN 'HEIGHT_05'.
      wa_measures-height_05 = numtab-value_from.
    WHEN 'LENGTH_05'.
      wa_measures-Length_05 = numtab-value_from.
    WHEN 'WEIGHT_05'.
      wa_measures-Weight_05 = numtab-value_from.
    WHEN 'WIDTH_06'.
      wa_measures-width_06 = numtab-value_from.
    WHEN 'HEIGHT_06'.
      wa_measures-height_06 = numtab-value_from.
    WHEN 'LENGTH_06'.
      wa_measures-Length_06 = numtab-value_from.
    WHEN 'WEIGHT_06'.
      wa_measures-Weight_06 = numtab-value_from.
    WHEN 'WIDTH_07'.
      wa_measures-width_07 = numtab-value_from.
    WHEN 'HEIGHT_07'.
      wa_measures-height_07 = numtab-value_from.
    WHEN 'LENGTH_07'.
      wa_measures-Length_07 = numtab-value_from.
    WHEN 'WEIGHT_07'.
      wa_measures-Weight_07 = numtab-value_from.
    WHEN 'WIDTH_08'.
      wa_measures-width_08 = numtab-value_from.
    WHEN 'HEIGHT_08'.
      wa_measures-height_08 = numtab-value_from.
    WHEN 'LENGTH_08'.
      wa_measures-Length_08 = numtab-value_from.
    WHEN 'WEIGHT_08'.
      wa_measures-Weight_08 = numtab-value_from.
    WHEN 'WIDTH_09'.
      wa_measures-width_09 = numtab-value_from.
    WHEN 'HEIGHT_09'.
      wa_measures-height_09 = numtab-value_from.
    WHEN 'LENGTH_09'.
      wa_measures-Length_09 = numtab-value_from.
    WHEN 'WEIGHT_09'.
      wa_measures-Weight_09 = numtab-value_from.
  ENDCASE.
  ENDLOOP.
  APPEND wa_measures to t_measures.
  CLEAR numtab.
ENDFORM.


FORM build_fieldcatelog.
  DATA: ls_fieldcat TYPE slis_fieldcat_alv.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 1.
  ls_fieldcat-fieldname = 'matnr'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Material'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 2.
  ls_fieldcat-fieldname = 'charg'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Batch'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 3.
  ls_fieldcat-fieldname = 'werks'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Plant'.
  APPEND ls_fieldcat TO t_fieldcatelog.

    CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 4.
  ls_fieldcat-fieldname = 'clabs'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'normal unrestr stock'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 6.
  ls_fieldcat-fieldname = 'kalab'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Sales order stock'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 7.
  ls_fieldcat-fieldname = 'Length_01'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Length_01'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 8.
  ls_fieldcat-fieldname = 'Width_01'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Width_01'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 9.
  ls_fieldcat-fieldname = 'Height_01'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Height_01'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 10.
  ls_fieldcat-fieldname = 'Weight_01'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Weight_01'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 11.
  ls_fieldcat-fieldname = 'Length_02'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Length_02'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 12.
  ls_fieldcat-fieldname = 'Width_02'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Width_02'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 13.
  ls_fieldcat-fieldname = 'Height_02'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Height_02'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 14.
  ls_fieldcat-fieldname = 'Weight_02'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Weight_02'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 15.
  ls_fieldcat-fieldname = 'Length_03'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Length_03'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 12.
  ls_fieldcat-fieldname = 'Width_03'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Width_03'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 13.
  ls_fieldcat-fieldname = 'Height_03'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Height_03'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 14.
  ls_fieldcat-fieldname = 'Weight_03'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Weight_03'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 15.
  ls_fieldcat-fieldname = 'Length_04'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Length_04'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 16.
  ls_fieldcat-fieldname = 'Width_04'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Width_04'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 17.
  ls_fieldcat-fieldname = 'Height_04'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Height_04'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 18.
  ls_fieldcat-fieldname = 'Weight_04'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Weight_04'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 19.
  ls_fieldcat-fieldname = 'Length_05'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Length_05'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 20.
  ls_fieldcat-fieldname = 'Width_05'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Width_05'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 21.
  ls_fieldcat-fieldname = 'Height_05'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Height_05'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 22.
  ls_fieldcat-fieldname = 'Weight_05'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Weight_05'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 23.
  ls_fieldcat-fieldname = 'maktx'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Mat desc'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CLEAR ls_fieldcat.
  ls_fieldcat-col_pos  = 24.
  ls_fieldcat-fieldname = 'lgort'.
  ls_fieldcat-tabname = 'T_OUTPUTDATA'.
  ls_fieldcat-seltext_m = 'Storage loc'.
  APPEND ls_fieldcat TO t_fieldcatelog.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = v_repid
      i_internal_tabname     = 't_OUTPUTDATA'
      i_structure_name       = 'ST_OUTPUTDATA'
      i_client_never_display = 'X'
      i_inclname             = v_repid
    CHANGING
      ct_fieldcat            = t_fieldcatelog[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
ENDFORM.                    "BUILD_FIELDCATELOG

*&amp;---------------------------------------------------------------------*
*&amp;      Form  BUILD_EVENTSINFO
*&amp;---------------------------------------------------------------------*
FORM build_eventsinfo.
  DATA: ls_event TYPE slis_alv_event.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = t_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

  READ TABLE t_events WITH KEY name = slis_ev_top_of_page INTO ls_event.
  IF sy-subrc = 0.
    MOVE 'TOP_OF_PAGE' TO ls_event-form.
    APPEND ls_event TO t_events.
  ENDIF.

  READ TABLE t_events WITH KEY name = slis_ev_user_command INTO ls_event.
  IF sy-subrc = 0.
    MOVE 'USER_COMMAND' TO ls_event-form.
    APPEND ls_event TO t_events.
  ENDIF.

ENDFORM.                    "BUILD_EVENTSINFO

*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
FORM build_layout USING ls_layout TYPE slis_layout_alv.
  ls_layout-coltab_fieldname = 'CELL_COLOR'.
ENDFORM.                    "BUILD_LAYOUT
*&amp;---------------------------------------------------------------------*
*&amp;      Form  BUILD_SORTINFO
*&amp;---------------------------------------------------------------------*
FORM build_sortinfo.
  DATA: ls_sort TYPE slis_sortinfo_alv.

  ls_sort-fieldname = 'werks'.
  ls_sort-spos = 1.
  ls_sort-up = 'X'.
  APPEND ls_sort TO t_sortinfo.

  CLEAR ls_sort.
  ls_sort-fieldname = 'matnr'.
  ls_sort-spos = 2.
  ls_sort-up = 'X'.
  APPEND ls_sort TO t_sortinfo.
ENDFORM.                    "BUILD_SORTINFO

FORM build_listheader.
  DATA: ls_line TYPE slis_listheader.

***Header
  CLEAR ls_line.
  ls_line-typ  = 'H'.
  ls_line-info = 'ASDFG'.
  APPEND ls_line TO t_listheader.

ENDFORM.                    "BUILD_LISTHEADER

*&amp;---------------------------------------------------------------------*
*&amp;      Form  TOP_OF_PAGE
*&amp;---------------------------------------------------------------------*
FORM top_of_page.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_listheader
      i_logo             = 'ENJOYSAP_LOGO'.
ENDFORM.                    "TOP_OF_PAGE

*&amp;---------------------------------------------------------------------*
*&amp;      Form  DISPLAY_LISTREPORT
*&amp;---------------------------------------------------------------------*
FORM display_listreport.
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program = v_repid
      i_structure_name   = 'ST_OUTPUTDATA'
      is_layout          = t_layout
      it_fieldcat        = t_fieldcatelog[]
      it_sort            = t_sortinfo[]
      it_events          = t_events[]
    TABLES
      t_outtab           = t_measures
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM.                    "DISPLAY_LISTREPORT

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_GRIDREPORT
*&---------------------------------------------------------------------*
FORM display_gridreport.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = v_repid
      i_structure_name   = 'ST_OUTPUTDATA'
      is_layout          = t_layout
      it_fieldcat        = t_fieldcatelog[]
      it_sort            = t_sortinfo[]
      it_events          = t_events[]
    TABLES
      t_outtab           = t_measures
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.                    "DISPLAY_GRIDREPORT