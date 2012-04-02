safe do
  local :path => "/backup/:kind/:id"

  s3 do
    key "AKIAIYSLNBUUK2TNGZTQ"
    secret "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"
    bucket "nisher"
    path "backup/:kind/:id"
  end
#
#  cloudfiles do
#    user "..........."
#    api_key "................................."
#    container "safe_backup"
#    path ":kind/" # this is default
#    service_net false
#  end
#
#  sftp do
#    host "sftp.astrails.com"
#    user "astrails"
#    # port 8023
#    password "ssh password for sftp"
#  end
#
#  gpg do
#    command "/usr/local/bin/gpg"
#    options  "--no-use-agent"
#    # symmetric encryption key
#    # password "qwe"
#
#    # public GPG key (must be known to GPG, i.e. be on the keyring)
#    key "backup@astrails.com"
#  end

  keep do
    local 20
    s3 20
#    cloudfiles 100
#    sftp 100
  end

#  mysqldump do
#    options "-ceKq --single-transaction --create-options"
#
#    user "root"
#    password "............"
#    socket "/var/run/mysqld/mysqld.sock"
#
#    database :blog
#    database :servershape
#    database :astrails_com
#    database :secret_project_com do
#      skip_tables "foo"
#      skip_tables ["bar", "baz"]
#    end
#
#  end
#
#  svndump do
#    repo :my_repo do
#      repo_path "/home/svn/my_repo"
#    end
#  end

  pgdump do
    options "-i -x -O"   # -i => ignore version, -x => do not dump privileges (grant/revoke), -O => skip restoration of object ownership in plain text format

    user "nisher"
    password "ni2010sher"  # shouldn't be used, instead setup ident.  Current functionality exports a password env to the shell which pg_dump uses - untested!

    database :nisher_production
  end

  tar do
    options "-h" # dereference symlinks
  #  archive "git-repositories", :files => "/home/git/repositories"
  #  archive "dot-configs",      :files => "/home/*/.[^.]*"
  #  archive "etc",              :files => "/etc", :exclude => "/etc/puppet/other"

    archive "nisher" do
      files "/var/web/nisher/"
      exclude "/var/web/nisher/log"
    #  exclude "/var/www/blog.astrails.com/log"
    #  exclude "/var/www/blog.astrails.com/tmp"
    end

  #  archive "astrails-com" do
  #    files "/var/www/astrails.com/"
  #    exclude ["/var/www/astrails.com/log", "/var/www/astrails.com/tmp"]
  #  end
  end
end
