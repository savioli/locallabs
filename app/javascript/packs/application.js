// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'bootstrap'
import jquery from 'jquery'
require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import $ from 'jquery'
import 'bootstrap-select'
import { domain } from 'process'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// $(document).on('page:load', function () {
// $(function() {

//     $('#status').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {
//         // do something...

//         var strd = window.location.href

//         // strd = strd.split( '?' )
//         // Turbolinks.visit('http://192.168.33.100/' + '?status=' + this.value)

//         console.log('http://192.168.33.100/' + '?status=' + this.value)

//         $(location).attr('href', 'http://192.168.33.100/' + '?status=' + this.value)

//     });

//     // $(document).on('ready page:load', function() {
//         // $("#status").selectpicker('refresh');
//     // })
    

// })

      

// });

// $(document).on('turbolinks:load', function() {

//     // $(function(){

//         $("#writer_or_reviewer").on('change', function() {
    
//             $(location).attr('href', '?writer_or_reviewer=' + this.value)
    
//         })
    
//         $('#status').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {
//             // do something...
    
//             var strd = window.location.href
    
//             // strd = strd.split( '?' )
//             Turbolinks.visit('http://192.168.33.100/' + '?status=' + this.value)
    
//             console.log('http://192.168.33.100/' + '?status=' + this.value)
    
//             // $(location).attr('href', 'http://192.168.33.100/' + '?status=' + this.value)
    
//         });
          
    
//         // $("#status").on( 'change', function() {
    
//         //     var strd = window.location.href
    
//         //     // strd = strd.split( '?' )
//         //     // Turbolinks.visit('http://192.168.33.100/' + '?status=' + this.value)
    
//         //     console.log('http://192.168.33.100/' + '?status=' + this.value)
    
//         //     // $(location).attr('href', 'http://192.168.33.100/' + '?status=' + this.value)
    
//         // })
    
//     // })
  
// });



// // $('#writer_or_reviewer').on('change', function(){

// //     // $(this).closest('form').submit();
// //     alert('ok')

// // });

function addQueryStringParameter( url, newKey, newValue, hostname = '' ) {
    
    var domain = url

    var new_url = domain

    domain = domain.split('?')


    if(hostname != '') {
        new_url = hostname
    } else {
        new_url = domain[0]
    }
    

    var keys = []
    var values = []

    if ( domain.length > 1 ) {

        var queryString = domain[1]

        var keyAndValue = queryString.split('&')

        for (let index = 0; index < keyAndValue.length; index++) {
            
            var element = keyAndValue[index];

            element = element.split('=')

            if(  element.length > 1 ){
                
                keys.push( element[0] )

                values.push( element[1] )

            }
            
        }

    }

    var hasParam = false
    
    for (let index = 0; index < keys.length; index++) {
        
        var key = keys[index];
        var value = values[index];

        if ( index == 0 ) {
        
            new_url = new_url + '?'
        
        } else {
            
            new_url = new_url + '&'

        }

        if ( key == newKey ) {
            
            hasParam = true

            new_url = new_url + key + '=' + newValue

        } else {

            new_url = new_url + key + '=' + value

        }
        
    }

    if ( hasParam == false ) {

        if ( keys.length == 0 ) {
        
            new_url = new_url + '?'
        
        } else {
            
            new_url = new_url + '&'

        }
        
        new_url = new_url + newKey + '=' + newValue

    }

    return new_url

}

$(function() {

    $('#writer_or_reviewer').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {

        var domain = window.location.href
        var hostname = window.location.origin

        var new_url = addQueryStringParameter( domain, 'writer', this.value, hostname )

        $(location).attr('href', new_url)

    });    


    $('#status').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {

        var domain = window.location.href
        var hostname = window.location.origin

        var new_url = addQueryStringParameter( domain, 'status', this.value, hostname )

        $(location).attr('href', new_url)

    });
    
    $('.bt-open, .bt-close').on( 'click', function(e){

        console.log($(this).parent().parent().find('.story-content').first())

        var storyContent = $(this).parent().parent().find('.story-content').first()

        var openButton = $(this).parent().find('.bt-open').first()
        var closeButton = $(this).parent().find('.bt-close').first()

        storyContent.slideToggle(500, function(){

            var isVisible = storyContent.css('display')


            // console.log(isVisible)
            console.log(openButton)
            console.log(closeButton)
            if( isVisible == 'none' ) {
                
                openButton.css({display: 'inline-block'});
                closeButton.css({display: 'none'});
        
            } else {

                openButton.css({display: 'none'});   
                closeButton.css({display: 'inline-block'});

            }

        })

        


    } )

})