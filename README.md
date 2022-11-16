---
description: A blank template and empty parameters file.
page_type: sample
products:
- azure
- azure-resource-manager
urlFragment: 100-blank-template
languages:
- json
- bicep
---
# Blank Template

![Azure Public Test Date](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/PublicLastTestDate.svg)
![Azure Public Test Result](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/PublicDeployment.svg)

![Azure US Gov Last Test Date](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/FairfaxLastTestDate.svg)
![Azure US Gov Last Test Result](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/FairfaxDeployment.svg)

![Best Practice Check](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/BestPracticeResult.svg)
![Cred Scan Check](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/CredScanResult.svg)

![Bicep Version](https://azurequickstartsservice.blob.core.windows.net/badges/100-blank-template/BicepVersion.svg)

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnanasess%2Fazure-miraclelinux-template%2Fmain%2Fazuredeploy.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnanasess%2Fazure-miraclelinux-template%2Fmain%2Fazuredeploy.json)

`Tags: empty, blank`

## WordPress の自動更新を設定する

```php
// wp-config.php
define('FS_METHOD', 'ssh2');
define('FTP_BASE', '/path/to/wp/');
define('FTP_CONTENT_DIR', '/path/to/wp/wp-content/');
define('FTP_PLUGIN_DIR ', '/path/to/wp/wp-content/plugins/');
define('FTP_PUBKEY', '/var/www/.ssh/id_rsa.pub');
define('FTP_PRIKEY', '/var/www/.ssh/id_rsa');
define('FTP_USER', '${adminUsername}');
define('FTP_HOST', 'localhost');
```

WordPress を Git で管理している場合は以下を追加
```php
// wp-content/themes/themeName/functions.php
add_filter( 'automatic_updates_is_vcs_checkout', '__return_false', 1 );
```

### See Also

- https://ja.wordpress.org/support/article/editing-wp-config-php/
- https://www.systemajik.com/wordpress-ssh2-configuration/
