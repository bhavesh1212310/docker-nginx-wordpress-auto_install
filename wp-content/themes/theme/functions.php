<?php 

add_theme_support( 'post-thumbnails' );
add_theme_support( 'nav-menus' );
function register_my_menus() {
register_nav_menus(
array(
'header-menu' => __( 'Header Menu' ),
'side-menu' => __( 'Side Menu' ),
'footer-menu' => __( 'Footer Menu' )
)
);
}
add_action( 'init', 'register_my_menus' );

?>