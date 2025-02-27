{application, ssl,
   [{description, "Erlang/OTP SSL application"},
    {vsn, "9.4"},
    {modules, [
	       %% TLS/SSL 
	       tls_connection,
	       tls_connection_1_3,
	       tls_handshake,
	       tls_handshake_1_3,
	       tls_record,
	       tls_record_1_3,
	       tls_socket,
	       tls_v1,
	       ssl_v3,
	       tls_connection_sup,
	       tls_sender,
	       ssl_dh_groups,
	       %% DTLS
	       dtls_connection,
	       dtls_handshake,
	       dtls_record,
	       dtls_socket,
	       dtls_v1,
	       dtls_connection_sup,
	       dtls_packet_demux,
	       dtls_listener_sup,
	       %% API
	       ssl,  %% Main API		  
	       ssl_session_cache_api,
	       %% Both TLS/SSL and DTLS
	       ssl_config,
	       ssl_connection,
	       ssl_handshake,
	       ssl_record,
	       ssl_cipher,
               ssl_cipher_format,
	       ssl_srp_primes,
	       ssl_alert,
	       ssl_listen_tracker_sup, %% may be used by DTLS over SCTP	
	       %% Erlang Distribution over SSL/TLS
	       inet_tls_dist,
	       inet6_tls_dist,
	       ssl_dist_sup,
               ssl_dist_connection_sup,
               ssl_dist_admin_sup,
	       %% SSL/TLS session and cert handling
	       ssl_session,
	       ssl_session_cache,
	       ssl_manager,
	       ssl_pem_cache,
	       ssl_pkix_db,
	       ssl_certificate,
	       %% CRL handling
	       ssl_crl,
	       ssl_crl_cache, 
	       ssl_crl_cache_api,
	       ssl_crl_hash_dir,
	       %% Logging
	       ssl_logger,
	       %% App structure
	       ssl_app,
	       ssl_sup,
	       ssl_admin_sup,
	       ssl_connection_sup
	       ]},
    {registered, [ssl_sup, ssl_manager]},
    {applications, [crypto, public_key, kernel, stdlib]},
    {env, []},
    {mod, {ssl_app, []}},
    {runtime_dependencies, ["stdlib-3.5","public_key-1.5","kernel-6.0",
			    "erts-10.0","crypto-4.2", "inets-5.10.7"]}]}.
