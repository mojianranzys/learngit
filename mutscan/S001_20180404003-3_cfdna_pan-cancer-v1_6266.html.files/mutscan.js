function toggle(targetid){ 
                if (document.getElementById){ 
                    target=document.getElementById(targetid); 
                        if (target.style.display=='table-row'){ 
                            target.style.display='none'; 
                        } else { 
                            target.style.display='table-row'; 
                        } 
                } 
            }function toggle_target_list(targetid){ 
                if (document.getElementById){ 
                    target=document.getElementById(targetid); 
                        if (target.style.display=='block'){ 
                            target.style.display='none'; 
                            document.getElementById('target_view_btn').value='view';
                        } else { 
                            document.getElementById('target_view_btn').value='hide';
                            target.style.display='block'; 
                        } 
                } 
            }