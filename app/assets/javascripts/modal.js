$(document).ready(function() {
  modal = $('#myModal');
  if (modal != null)
    modal.modal('toggle');
  if ($('.card_detail').get(0)) {
    $('#wrapper').removeClass('position');
    $('#task_name').click(function () {
      $('#task_name').addClass('hide');
      $('#task_id').removeClass('hide').focus();
    });
    $('#task_id').focusout(function () {
      $('#task_name').removeClass('hide');
      $('#task_id').addClass('hide');
    }).change(function () {
      $('#task_form').submit();
    });
  }
});
