({
	doInit : function(component, event, helper) {
		var id = (new Date()).getTime( );
        component.set( "v.id", id );
        $A[ 'youtube-videoplayer' + id ] = {};
        if( component.get( "v.fullscreen") ){
            component.set( "v.width", "100%" );
            component.set( "v.height", "100%" );
            component.set( "v.fullscreen_class", "full_screen" );
        };
        var grayscale = component.get( "v.effect");
        switch( grayscale ){
            case 'Invert':
                component.set( "v.effect_class", "invert" );
                break;
            case 'Grayscale light':
                component.set( "v.effect_class", "gray_light" );
                break;
            case 'Grayscale strong':
                component.set( "v.effect_class", "gray_strong" );
                break;
            case 'Sepia light':
                component.set( "v.effect_class", "sepia_light" );
                break;
            case 'Sepia strong':
                component.set( "v.effect_class", "sepia_strong" );
                break;
            case 'Blur light':
                component.set( "v.effect_class", "blur_light" );
                break;
            case 'Blur strong':
                component.set( "v.effect_class", "blur_strong" );
                break;
            default:
                component.set( "v.effect_class", "" );
        };
	},
    afterScriptsLoaded : function(component, event, helper) { 
        console.log("hey")
        var youtube_videoplayer = $A[ 'youtube-videoplayer' + component.get( "v.id") ];
		youtube_videoplayer = new YoutubeVideo();
        youtube_videoplayer.init( {
            id: component.get( 'v.id'),
            fullscreen: component.get( 'v.fullscreen' )
        });
        
       utility.onPageLoad( function(){
            utility.onWindowResize( youtube_videoplayer.adjustImgSizeOnWinResize );
        });
        
        utility.init( );
	}
})