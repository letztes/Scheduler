
$(document).ready(function(){
    $("div.icons").mouseover(function() {
        $(this).addClass('hovered');
    }).mouseout(function() {
        $(this).removeClass('hovered');
    });
    
    $( document ).tooltip();
    
});
