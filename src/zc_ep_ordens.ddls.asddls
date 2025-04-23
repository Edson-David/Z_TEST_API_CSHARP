@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo das Ordens'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_EP_ORDENS
  as projection on ZI_EP_ORDENS
{
  key Ordem,
      Maquina,
      Setor,
      Descricao,
      Status
}
