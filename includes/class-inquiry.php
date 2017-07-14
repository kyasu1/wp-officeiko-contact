<?php

class Inquiry {

  private $plugin_meta;

  public function __construct( $plugin_meta = array() ) {

    if ( empty( $plugin_meta ) ) {
      return;
    }

    $this->plugin_meta = $plugin_meta;

    add_action( 'wp_enqueue_scripts', array( $this, 'enqueue_scripts' ));
  }

  public function enqueue_scripts() {

    $json = file_get_contents( plugin_dir_path($this->plugin_meta['file']) . 'includes/webpack-assets.json' );
    $data = json_decode($json, TRUE);

    $script_handle = $this->plugin_meta['slug'] . '-main';

    wp_enqueue_script(
      $script_handle = $this->plugin_meta['slug'] . '-elm',
      plugin_dir_url( $this->plugin_meta['file'] ) . $data['app']['js'],
      array(),
      $this->plugin_meta['version'],
      true
    );

    wp_enqueue_style(
      $script_handle = $this->plugin_meta['slug'] . '-elm',
      plugin_dir_url( $this->plugin_meta['file'] ) . $data['app']['css'],
      array(),
      $this->plugin_meta['version'],
      'all'
    );
  }
}
