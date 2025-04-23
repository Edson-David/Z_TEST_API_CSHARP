CLASS lhc_Ordens DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Ordens RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Ordens.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Ordens.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Ordens.

    METHODS read FOR READ
      IMPORTING keys FOR READ Ordens RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Ordens.

ENDCLASS.

CLASS lhc_Ordens IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lf_ordens>).

      DATA(lo_uuid) = cl_uuid_factory=>create_system_uuid( ).
      DATA(lo_instance) = zcl_ep_ordens=>get_instance( ).
      DATA(ls_ordens) = CORRESPONDING ztep_ordens( <lf_ordens> ).

      ls_ordens-ordem = lo_uuid->create_uuid_x16( ).
      APPEND ls_ordens  TO zcl_ep_ordens=>gt_ordens.

      INSERT VALUE #(
        %cid = <lf_ordens>-%cid
        %key = <lf_ordens>-%key
        ordem = ls_ordens-ordem
      ) INTO TABLE mapped-ordens.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    TYPES: tt_ordens   TYPE TABLE OF ztep_ordens WITH DEFAULT KEY,
           tt_ordens_x TYPE TABLE OF zsep_ordens WITH DEFAULT KEY.

    DATA(lt_ordens) = CORRESPONDING tt_ordens( entities MAPPING FROM ENTITY ).
    DATA(lt_ordens_x) = CORRESPONDING tt_ordens_x( entities MAPPING FROM ENTITY USING CONTROL ).

    IF lt_ordens IS NOT INITIAL.

      SELECT FROM ztep_ordens
      FIELDS
          ordem,
          maquina,
          setor,
          descricao,
          status
      FOR ALL ENTRIES IN @entities
      WHERE ordem = @entities-Ordem
      INTO TABLE @DATA(lt_ordens_old).

      zcl_ep_ordens=>gt_ordens = VALUE #( FOR ls IN lt_ordens
        LET ls_control_flag = VALUE #( lt_ordens_x[ 1 ] OPTIONAL )
            ls_ordens_new = VALUE #( lt_ordens[ ordem = ls-ordem ] OPTIONAL )
            ls_ordens_old = VALUE #( lt_ordens_old[ ordem = ls-ordem ] OPTIONAL )
        IN ( ordem = COND #( WHEN ls_control_flag-ordem IS NOT INITIAL THEN ls_ordens_new-ordem
                               ELSE ls_ordens_old-ordem )
             maquina = COND #( WHEN ls_control_flag-maquina IS NOT INITIAL THEN ls_ordens_new-maquina
                               ELSE ls_ordens_old-maquina )
             setor = COND #( WHEN ls_control_flag-setor IS NOT INITIAL THEN ls_ordens_new-setor
                             ELSE ls_ordens_old-setor )
             descricao = COND #( WHEN ls_control_flag-descricao IS NOT INITIAL THEN ls_ordens_new-descricao
                                 ELSE ls_ordens_old-descricao )
             status = cond #(  when ls_control_flag-status is not initial then ls_ordens_new-status
                               else ls_ordens_old-status )
    )  ).

    ENDIF.

  ENDMETHOD.

  METHOD delete.

    DATA: lt_ordens_delete TYPE TABLE OF ztep_ordens WITH DEFAULT KEY.
          lt_ordens_delete = CORRESPONDING #( keys MAPPING FROM ENTITY ).

    zcl_ep_ordens=>gr_ordem_delete = VALUE #(
    FOR ls_ordens_delete IN lt_ordens_delete
    sign = 'I'
    option = 'EQ'
    ( low = ls_ordens_delete-ordem )
    ).

  ENDMETHOD.

  METHOD read.

  SELECT * FROM ztep_ordens
    FOR ALL ENTRIES IN @keys
    WHERE ordem = @keys-Ordem
    INTO TABLE @DATA(lt_ordens).

    result = CORRESPONDING #( lt_ordens MAPPING TO ENTITY ).

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_EP_ORDENS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_EP_ORDENS IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    MODIFY ztep_ordens FROM TABLE @zcl_ep_ordens=>gt_ordens.

    CLEAR zcl_ep_ordens=>gt_ordens.

    IF zcl_ep_ordens=>gr_ordem_delete IS NOT INITIAL.
      DELETE FROM ztep_ordens WHERE ordem IN @zcl_ep_ordens=>gr_ordem_delete.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
