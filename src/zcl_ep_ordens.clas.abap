CLASS zcl_ep_ordens DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-DATA: go_instance     TYPE REF TO zcl_ep_ordens,
                gt_ordens       TYPE TABLE OF ztep_ordens,
                gr_ordem_delete TYPE RANGE OF ztep_ordens-ordem.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_ep_ordens.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ep_ordens IMPLEMENTATION.
  METHOD get_instance.

    go_instance = ro_instance = COND #(
        WHEN go_instance IS BOUND THEN go_instance
        ELSE NEW #(  )
    ).

  ENDMETHOD.

ENDCLASS.
