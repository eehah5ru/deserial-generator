$( document ).ready(function() {
	// alert("!!!!!");
	$('#content').find("div").hover(function () {
		// alert("!!!!!");
		toggleFontSize(this);
	});
});


function toggleFontSize (an_element) {
	// alert($(an_element).css("font-size"));
	var newFontSize = 0;
	while (newFontSize < 5) {
		newFontSize = $(an_element).css("font-size").replace("px", "") * (Math.random() + Math.random());
	}
	// console.log($(an_element).css("font-size"));
	// console.log(newFontSize);
	$(an_element).css("font-size", newFontSize + "px");
}