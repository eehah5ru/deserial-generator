$( document ).ready(function() {
	correctCharactersToggleDependentElemetsStatus();
	
	$('.characters-toggle').bind('click', function () {
		toggleInputStatuses(this);
	});
});

function correctCharactersToggleDependentElemetsStatus () {
	var toggler = $('.characters-toggle').first();
	
	toggleInputStatuses(toggler);
}


function toggleInputStatuses (an_element) {
	var inputs = $(".characters-toggle-dependent");
	
  
  if ($(an_element).is(':checked')) {
      inputs.attr('disabled', true);
  } else {
      inputs.removeAttr('disabled');
  }	
}
