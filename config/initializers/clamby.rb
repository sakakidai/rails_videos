Clamby.configure({
  check: true,
  daemonize: true,
  config_file: nil,
  error_clamscan_missing: true, # コマンドのパスが見つからない時、エラー
  error_clamscan_client_error: true, # デーモンプロセスが存在しない時、エラー
  error_file_missing: true, # 対象のファイルが見つからない時、エラー
  error_file_virus: true, # 対象のファイルからエラーを検知した時、エラー
  fdpass: false,
  stream: false,
  output_level: 'medium', # one of 'off', 'low', 'medium', 'high'
  executable_path_clamscan: 'clamscan',
  executable_path_clamdscan: 'clamdscan',
  executable_path_freshclam: 'freshclam',
})
