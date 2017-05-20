<!DOCTYPE html>
<html>
<head>
	<title><?php bloginfo('name'); ?></title>
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
	 <?php wp_head(); ?>
	<link rel="stylesheet" href="<?php bloginfo('template_directory');?>/style.css">
	<link rel="stylesheet" href="<?php bloginfo('template_directory');?>/styles.css">
</head>

<body>
    <nav class="nav">
      <?php wp_nav_menu( array( 'container' => false, 'theme_location' => 'header-menu',  ) ); ?>
    </nav>