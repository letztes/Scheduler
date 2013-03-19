
$(document).ready(function(){
    $("div.icons").mouseover(function() {
        $(this).addClass('hovered');
    }).mouseout(function() {
        $(this).removeClass('hovered');
    });
});

function mark_task_as_done(user_id,task_id) {
    
    var request = $.ajax({
        url:  "?",
        type: "POST",
        data: {
            todo: "mark_task_as_done",
            user_id: user_id,
            task_id: task_id,
        }
    });
    
    request.done(function( msg ) {
        $( '#div_'+task_id ).css( 'display', 'none' );
    });
    
    //request.fail(function(jqXHR, textStatus) {
        //alert( "Request failed: " + textStatus );
    //});
};
        
        
