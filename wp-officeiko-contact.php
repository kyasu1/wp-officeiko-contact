<?php
/**
 * @link              https://github.com/kyasu1/wp-officeiko-contact
 * @since             0.1.0
 * @package           OfficeIKO
 *
 * @wordpress-plugin
 * Plugin Name:       WP Yahoo Auction Inquiry
 * Plugin URI:        https://github.com/kyasu1/wp-officeiko-contact
 * Description:       A little dashboard widget to manage the WordPress cron.
 * Version:           0.1.0
 * Author:            Yasuyuki Komatsubara
 * Author URI:        http://www.officeiko.co.jp/
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       wp-cron-pixie
 * Domain Path:       /languages
 * Network:           False
 */

	// If this file is called directly, abort.
	if ( ! defined( 'WPINC' ) ) {
	    die;
	}

	function inquiry_meta() {
		return array(
			'slug' => 'wp-auction-inquiry',
			'name' => 'WP Auction Inquiry',
			'file' => __FILE__,
			'version' => '0.1.0'
		);
	}

	require plugin_dir_path( __FILE__ ) . 'includes/class-inquiry.php';

	function inquiry_init() {
		$inquiry = new Inquiry( inquiry_meta() );

		return '<div id="wp-auction-inquiry"><div>';
	}

	add_shortcode('wp_auction_inquiry', 'inquiry_init');
?>

