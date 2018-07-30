=begin
#Zuora API Reference

#  # Introduction Welcome to the reference for the Zuora REST API!  <a href=\"http://en.wikipedia.org/wiki/REST_API\" target=\"_blank\">REST</a> is a web-service protocol that lends itself to rapid development by using everyday HTTP and JSON technology.  The Zuora REST API provides a broad set of operations and resources that:    * Enable Web Storefront integration from your website.   * Support self-service subscriber sign-ups and account management.   * Process revenue schedules through custom revenue rule models.   * Enable manipulation of most objects in the Zuora Object Model.  Want to share your opinion on how our API works for you? <a href=\"https://community.zuora.com/t5/Developers/API-Feedback-Form/gpm-p/21399\" target=\"_blank\">Tell us how you feel </a>about using our API and what we can do to make it better.    ## Endpoints      The Zuora REST API is provided via the following endpoints.   | Tenant              | Base URL for REST Endpoints |   |-------------------------|-------------------------|   |US Production | https://rest.zuora.com   |   |US API Sandbox    | https://rest.apisandbox.zuora.com|   |US Performance Test | https://rest.pt1.zuora.com |   |EU Production | https://rest.eu.zuora.com |   |EU Sandbox | https://rest.sandbox.eu.zuora.com |      The production endpoint provides access to your live user data. The API Sandbox tenant is a good place to test your code without affecting real-world data. To use it, you must be provisioned with an API Sandbox tenant - your Zuora representative can help you if needed.      ## Access to the API      If you have a Zuora tenant, you already have access to the API.      If you don't have a Zuora tenant, go to <a href=\" https://www.zuora.com/resource/zuora-test-drive\" target=\"_blank\">https://www.zuora.com/resource/zuora-test-drive</a> and sign up for a Production Test Drive tenant. The tenant comes with seed data, such as a sample product catalog.  We recommend that you <a href=\"https://knowledgecenter.zuora.com/CF_Users_and_Administrators/A_Administrator_Settings/Manage_Users/Create_an_API_User\" target=\"_blank\">create an API user</a> specifically for making API calls. Don't log in to the Zuora UI with this account. Logging in to the UI enables a security feature that periodically expires the account's password, which may eventually cause authentication failures with the API. Note that a user role does not have write access to Zuora REST services unless it has the API Write Access permission as described in those instructions.   # API Changelog You can find the <a href=\"https://community.zuora.com/t5/Developers/API-Changelog/gpm-p/18092\" target=\"_blank\">Changelog</a> of the API Reference in the Zuora Community.   # Authentication  ## OAuth v2.0  Zuora recommends that you use OAuth v2.0 to authenticate to the Zuora REST API. Currently, OAuth is not available in every environment. See [Zuora Testing Environments](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/D_Zuora_Environments) for more information.  Zuora recommends you to create a dedicated API user with API write access on a tenant when authenticating via OAuth, and then create an OAuth client for this user. By doing this, you can control permissions of the API user without affecting other non-API users. Note that if a user is deactivated, all his OAuth clients will be automatically deactivated.  Authenticating via OAuth requires the following steps: 1. Create a Client 2. Generate a Token 3. Make Authenticated Requests  ### Create a Client  You must first [create an OAuth client](https://knowledgecenter.zuora.com/CF_Users_and_Administrators/A_Administrator_Settings/Manage_Users#Create_an_OAuth_Client_for_a_User) in the Zuora UI. To do this, you must be an administrator of your Zuora tenant. This is a one-time operation. You will be provided with a Client ID and a Client Secret. Please note this information down, as it will be required for the next step.  **Note:** The OAuth client will be owned by a Zuora user account. If you want to perform PUT, POST, or DELETE operations using the OAuth client, the owner of the OAuth client must have a Platform role that includes the \"API Write Access\" permission.  ### Generate a Token  After creating a client, you must make a call to obtain a bearer token using the [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) operation. This operation requires the following parameters: - `client_id` - the Client ID displayed when you created the OAuth client in the previous step - `client_secret` - the Client Secret displayed when you created the OAuth client in the previous step - `grant_type` - must be set to `client_credentials`  **Note**: The Client ID and Client Secret mentioned above were displayed when you created the OAuth Client in the prior step. The [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) response specifies how long the bearer token is valid for. Call [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) again to generate a new bearer token.  ### Make Authenticated Requests  To authenticate subsequent API requests, you must provide a valid bearer token in an HTTP header:  `Authorization: Bearer {bearer_token}`  If you have [Zuora Multi-entity](https://www.zuora.com/developer/api-reference/#tag/Entities) enabled, you need to set an additional header to specify the ID of the entity that you want to access. You can use the `scope` field in the [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) response to determine whether you need to specify an entity ID.  If the `scope` field contains more than one entity ID, you must specify the ID of the entity that you want to access. For example, if the `scope` field contains `entity.1a2b7a37-3e7d-4cb3-b0e2-883de9e766cc` and `entity.c92ed977-510c-4c48-9b51-8d5e848671e9`, specify one of the following headers: - `Zuora-Entity-Ids: 1a2b7a37-3e7d-4cb3-b0e2-883de9e766cc` - `Zuora-Entity-Ids: c92ed977-510c-4c48-9b51-8d5e848671e9`  **Note**: For a limited period of time, Zuora will accept the `entityId` header as an alternative to the `Zuora-Entity-Ids` header. If you choose to set the `entityId` header, you must remove all \"-\" characters from the entity ID in the `scope` field.  If the `scope` field contains a single entity ID, you do not need to specify an entity ID.   ## Other Supported Authentication Schemes  Zuora continues to support the following additional legacy means of authentication:    * Use username and password. Include authentication with each request in the header:         * `apiAccessKeyId`      * `apiSecretAccessKey`    * Use an authorization cookie. The cookie authorizes the user to make calls to the REST API for the duration specified in  **Administration > Security Policies > Session timeout**. The cookie expiration time is reset with this duration after every call to the REST API. To obtain a cookie, call the [Connections](https://www.zuora.com/developer/api-reference/#tag/Connections) resource with the following API user information:         *   ID         *   password        * For CORS-enabled APIs only: Include a 'single-use' token in the request header, which re-authenticates the user with each request. See below for more details.  ### Entity Id and Entity Name  The `entityId` and `entityName` parameters are only used for [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity \"Zuora Multi-entity\"). These are the legacy parameters that Zuora will only continue to support for a period of time. Zuora recommends you to use the `Zuora-Entity-Ids` parameter instead.   The  `entityId` and `entityName` parameters specify the Id and the [name of the entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity/B_Introduction_to_Entity_and_Entity_Hierarchy#Name_and_Display_Name \"Introduction to Entity and Entity Hierarchy\") that you want to access, respectively. Note that you must have permission to access the entity.   You can specify either the `entityId` or `entityName` parameter in the authentication to access and view an entity.    * If both `entityId` and `entityName` are specified in the authentication, an error occurs.    * If neither `entityId` nor `entityName` is specified in the authentication, you will log in to the entity in which your user account is created.      To get the entity Id and entity name, you can use the GET Entities REST call. For more information, see [API User Authentication](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity/A_Overview_of_Multi-entity#API_User_Authentication \"API User Authentication\").      ### Token Authentication for CORS-Enabled APIs      The CORS mechanism enables REST API calls to Zuora to be made directly from your customer's browser, with all credit card and security information transmitted directly to Zuora. This minimizes your PCI compliance burden, allows you to implement advanced validation on your payment forms, and  makes your payment forms look just like any other part of your website.    For security reasons, instead of using cookies, an API request via CORS uses **tokens** for authentication.  The token method of authentication is only designed for use with requests that must originate from your customer's browser; **it should  not be considered a replacement to the existing cookie authentication** mechanism.  See [Zuora CORS REST](https://knowledgecenter.zuora.com/DC_Developers/REST_API/A_REST_basics/G_CORS_REST \"Zuora CORS REST\") for details on how CORS works and how you can begin to implement customer calls to the Zuora REST APIs. See  [HMAC Signatures](https://www.zuora.com/developer/api-reference/#operation/POSTHMACSignature \"HMAC Signatures\") for details on the HMAC method that returns the authentication token.  # Requests and Responses  ## Request IDs  As a general rule, when asked to supply a \"key\" for an account or subscription (accountKey, account-key, subscriptionKey, subscription-key), you can provide either the actual ID or  the number of the entity.  ## HTTP Request Body  Most of the parameters and data accompanying your requests will be contained in the body of the HTTP request.   The Zuora REST API accepts JSON in the HTTP request body. No other data format (e.g., XML) is supported.  ### Data Type  ([Actions](https://www.zuora.com/developer/api-reference/#tag/Actions) and CRUD operations only) We recommend that you do not specify the decimal values with quotation marks, commas, and spaces. Use characters of `+-0-9.eE`, for example, `5`, `1.9`, `-8.469`, and `7.7e2`. Also, Zuora does not convert currencies for decimal values.  ## Testing a Request  Use a third party client, such as [curl](https://curl.haxx.se \"curl\"), [Postman](https://www.getpostman.com \"Postman\"), or [Advanced REST Client](https://advancedrestclient.com \"Advanced REST Client\"), to test the Zuora REST API.  You can test the Zuora REST API from the Zuora API Sandbox or Production tenants. If connecting to Production, bear in mind that you are working with your live production data, not sample data or test data.  ## Testing with Credit Cards  Sooner or later it will probably be necessary to test some transactions that involve credit cards. For suggestions on how to handle this, see [Going Live With Your Payment Gateway](https://knowledgecenter.zuora.com/CB_Billing/M_Payment_Gateways/C_Managing_Payment_Gateways/B_Going_Live_Payment_Gateways#Testing_with_Credit_Cards \"C_Zuora_User_Guides/A_Billing_and_Payments/M_Payment_Gateways/C_Managing_Payment_Gateways/B_Going_Live_Payment_Gateways#Testing_with_Credit_Cards\" ).  ## Concurrent Request Limits  Zuora enforces tenant-level concurrent request limits. See <a href=\"https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Policies/Concurrent_Request_Limits\" target=\"_blank\">Concurrent Request Limits</a> for more information.    ## Error Handling  Responses and error codes are detailed in [Responses and errors](https://knowledgecenter.zuora.com/DC_Developers/REST_API/A_REST_basics/3_Responses_and_errors \"Responses and errors\").  # Pagination  When retrieving information (using GET methods), the optional `pageSize` query parameter sets the maximum number of rows to return in a response. The maximum is `40`; larger values are treated as `40`. If this value is empty or invalid, `pageSize` typically defaults to `10`.  The default value for the maximum number of rows retrieved can be overridden at the method level.  If more rows are available, the response will include a `nextPage` element, which contains a URL for requesting the next page.  If this value is not provided, no more rows are available. No \"previous page\" element is explicitly provided; to support backward paging, use the previous call.  ## Array Size  For data items that are not paginated, the REST API supports arrays of up to 300 rows.  Thus, for instance, repeated pagination can retrieve thousands of customer accounts, but within any account an array of no more than 300 rate plans is returned.  # API Versions  The Zuora REST API are version controlled. Versioning ensures that Zuora REST API changes are backward compatible. Zuora uses a major and minor version nomenclature to manage changes. By specifying a version in a REST request, you can get expected responses regardless of future changes to the API.  ## Major Version  The major version number of the REST API appears in the REST URL. Currently, Zuora only supports the **v1** major version. For example, `POST https://rest.zuora.com/v1/subscriptions`.  ## Minor Version  Zuora uses minor versions for the REST API to control small changes. For example, a field in a REST method is deprecated and a new field is used to replace it.   Some fields in the REST methods are supported as of minor versions. If a field is not noted with a minor version, this field is available for all minor versions. If a field is noted with a minor version, this field is in version control. You must specify the supported minor version in the request header to process without an error.   If a field is in version control, it is either with a minimum minor version or a maximum minor version, or both of them. You can only use this field with the minor version between the minimum and the maximum minor versions. For example, the `invoiceCollect` field in the POST Subscription method is in version control and its maximum minor version is 189.0. You can only use this field with the minor version 189.0 or earlier.  If you specify a version number in the request header that is not supported, Zuora will use the minimum minor version of the REST API. In our REST API documentation, if a field or feature requires a minor version number, we note that in the field description.  You only need to specify the version number when you use the fields require a minor version. To specify the minor version, set the `zuora-version` parameter to the minor version number in the request header for the request call. For example, the `collect` field is in 196.0 minor version. If you want to use this field for the POST Subscription method, set the  `zuora-version` parameter to `196.0` in the request header. The `zuora-version` parameter is case sensitive.  For all the REST API fields, by default, if the minor version is not specified in the request header, Zuora will use the minimum minor version of the REST API to avoid breaking your integration.   ### Minor Version History  The supported minor versions are not serial. This section documents the changes made to each Zuora REST API minor version.  The following table lists the supported versions and the fields that have a Zuora REST API minor version.  | Fields         | Minor Version      | REST Methods    | Description | |:--------|:--------|:--------|:--------| | invoiceCollect | 189.0 and earlier  | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Generates an invoice and collects a payment for a subscription. | | collect        | 196.0 and later    | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Collects an automatic payment for a subscription. | | invoice | 196.0 and 207.0| [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Generates an invoice for a subscription. | | invoiceTargetDate | 196.0 and earlier  | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\") |Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | invoiceTargetDate | 207.0 and earlier  | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | targetDate | 207.0 and later | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\") |Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | targetDate | 211.0 and later | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | includeExisting DraftInvoiceItems | 196.0 and earlier| [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | Specifies whether to include draft invoice items in subscription previews. Specify it to be `true` (default) to include draft invoice items in the preview result. Specify it to be `false` to excludes draft invoice items in the preview result. | | includeExisting DraftDocItems | 207.0 and later  | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | Specifies whether to include draft invoice items in subscription previews. Specify it to be `true` (default) to include draft invoice items in the preview result. Specify it to be `false` to excludes draft invoice items in the preview result. | | previewType | 196.0 and earlier| [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | The type of preview you will receive. The possible values are `InvoiceItem`(default), `ChargeMetrics`, and `InvoiceItemChargeMetrics`. | | previewType | 207.0 and later  | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | The type of preview you will receive. The possible values are `LegalDoc`(default), `ChargeMetrics`, and `LegalDocChargeMetrics`. | | runBilling  | 211.0 and later  | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Generates an invoice or credit memo for a subscription. **Note:** Credit memos are only available if you have the Advanced AR Settlement feature enabled. | | invoiceDate | 214.0 and earlier  | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date that should appear on the invoice being generated, as `yyyy-mm-dd`. | | invoiceTargetDate | 214.0 and earlier  | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date through which to calculate charges on this account if an invoice is generated, as `yyyy-mm-dd`. | | documentDate | 215.0 and later | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date that should appear on the invoice and credit memo being generated, as `yyyy-mm-dd`. | | targetDate | 215.0 and later | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date through which to calculate charges on this account if an invoice or a credit memo is generated, as `yyyy-mm-dd`. |  #### Version 207.0 and Later  The response structure of the [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\") and [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") methods are changed. The following invoice related response fields are moved to the invoice container:    * amount   * amountWithoutTax   * taxAmount   * invoiceItems   * targetDate   * chargeMetrics  # Zuora Object Model  The following diagram presents a high-level view of the key Zuora objects. Click the image to open it in a new tab to resize it.  <a href=\"https://www.zuora.com/wp-content/uploads/2017/01/ZuoraERD.jpeg\" target=\"_blank\"><img src=\"https://www.zuora.com/wp-content/uploads/2017/01/ZuoraERD.jpeg\" alt=\"Zuora Object Model Diagram\"></a>  You can use the [Describe object](https://www.zuora.com/developer/api-reference/#operation/GET_Describe) operation to list the fields of each Zuora object that is available in your tenant. When you call the operation, you must specify the API name of the Zuora object.  The following table provides the API name of each Zuora object:  | Object                                        | API Name                                   | |-----------------------------------------------|--------------------------------------------| | Account                                       | `Account`                                  | | Accounting Code                               | `AccountingCode`                           | | Accounting Period                             | `AccountingPeriod`                         | | Amendment                                     | `Amendment`                                | | Application Group                             | `ApplicationGroup`                         | | Billing Run                                   | `BillRun`                               | | Contact                                       | `Contact`                                  | | Contact Snapshot                              | `ContactSnapshot`                          | | Credit Balance Adjustment                     | `CreditBalanceAdjustment`                  | | Credit Memo                                   | `CreditMemo`                               | | Credit Memo Application                       | `CreditMemoApplication`                    | | Credit Memo Application Item                  | `CreditMemoApplicationItem`                | | Credit Memo Item                              | `CreditMemoItem`                           | | Credit Memo Part                              | `CreditMemoPart`                           | | Credit Memo Part Item                         | `CreditMemoPartItem`                       | | Credit Taxation Item                          | `CreditTaxationItem`                       | | Custom Exchange Rate                          | `FXCustomRate`                             | | Debit Memo                                    | `DebitMemo`                                | | Debit Memo Item                               | `DebitMemoItem`                            | | Debit Taxation Item                           | `DebitTaxationItem`                        | | Discount Applied Metrics                      | `DiscountAppliedMetrics`                   | | Entity                                        | `Tenant`                                   | | Gateway Reconciliation Event                  | `PaymentGatewayReconciliationEventLog`     | | Gateway Reconciliation Job                    | `PaymentReconciliationJob`                 | | Gateway Reconciliation Log                    | `PaymentReconciliationLog`                 | | Invoice                                       | `Invoice`                                  | | Invoice Adjustment                            | `InvoiceAdjustment`                        | | Invoice Item                                  | `InvoiceItem`                              | | Invoice Item Adjustment                       | `InvoiceItemAdjustment`                    | | Invoice Payment                               | `InvoicePayment`                           | | Journal Entry                                 | `JournalEntry`                             | | Journal Entry Item                            | `JournalEntryItem`                         | | Journal Run                                   | `JournalRun`                               | | Order                                         | `Order`                                    | | Order Action                                  | `OrderAction`                              | | Order MRR                                     | `OrderMrr`                                 | | Order Quantity                                | `OrderQuantity`                            | | Order TCB                                     | `OrderTcb`                                 | | Order TCV                                     | `OrderTcv`                                 | | Payment                                       | `Payment`                                  | | Payment Application                           | `PaymentApplication`                       | | Payment Application Item                      | `PaymentApplicationItem`                   | | Payment Method                                | `PaymentMethod`                            | | Payment Method Snapshot                       | `PaymentMethodSnapshot`                    | | Payment Method Transaction Log                | `PaymentMethodTransactionLog`              | | Payment Method Update                         | `UpdaterDetail`                            | | Payment Part                                  | `PaymentPart`                              | | Payment Part Item                             | `PaymentPartItem`                          | | Payment Run                                   | `PaymentRun`                               | | Payment Transaction Log                       | `PaymentTransactionLog`                    | | Processed Usage                               | `ProcessedUsage`                           | | Product                                       | `Product`                                  | | Product Rate Plan                             | `ProductRatePlan`                          | | Product Rate Plan Charge                      | `ProductRatePlanCharge`                    | | Product Rate Plan Charge Tier                 | `ProductRatePlanChargeTier`                | | Rate Plan                                     | `RatePlan`                                 | | Rate Plan Charge                              | `RatePlanCharge`                           | | Rate Plan Charge Tier                         | `RatePlanChargeTier`                       | | Refund                                        | `Refund`                                   | | Refund Application                            | `RefundApplication`                        | | Refund Application Item                       | `RefundApplicationItem`                    | | Refund Invoice Payment                        | `RefundInvoicePayment`                     | | Refund Part                                   | `RefundPart`                               | | Refund Part Item                              | `RefundPartItem`                           | | Refund Transaction Log                        | `RefundTransactionLog`                     | | Revenue Charge Summary                        | `RevenueChargeSummary`                     | | Revenue Charge Summary Item                   | `RevenueChargeSummaryItem`                 | | Revenue Event                                 | `RevenueEvent`                             | | Revenue Event Credit Memo Item                | `RevenueEventCreditMemoItem`               | | Revenue Event Debit Memo Item                 | `RevenueEventDebitMemoItem`                | | Revenue Event Invoice Item                    | `RevenueEventInvoiceItem`                  | | Revenue Event Invoice Item Adjustment         | `RevenueEventInvoiceItemAdjustment`        | | Revenue Event Item                            | `RevenueEventItem`                         | | Revenue Event Item Credit Memo Item           | `RevenueEventItemCreditMemoItem`           | | Revenue Event Item Debit Memo Item            | `RevenueEventItemDebitMemoItem`            | | Revenue Event Item Invoice Item               | `RevenueEventItemInvoiceItem`              | | Revenue Event Item Invoice Item Adjustment    | `RevenueEventItemInvoiceItemAdjustment`    | | Revenue Event Type                            | `RevenueEventType`                         | | Revenue Schedule                              | `RevenueSchedule`                          | | Revenue Schedule Credit Memo Item             | `RevenueScheduleCreditMemoItem`            | | Revenue Schedule Debit Memo Item              | `RevenueScheduleDebitMemoItem`             | | Revenue Schedule Invoice Item                 | `RevenueScheduleInvoiceItem`               | | Revenue Schedule Invoice Item Adjustment      | `RevenueScheduleInvoiceItemAdjustment`     | | Revenue Schedule Item                         | `RevenueScheduleItem`                      | | Revenue Schedule Item Credit Memo Item        | `RevenueScheduleItemCreditMemoItem`        | | Revenue Schedule Item Debit Memo Item         | `RevenueScheduleItemDebitMemoItem`         | | Revenue Schedule Item Invoice Item            | `RevenueScheduleItemInvoiceItem`           | | Revenue Schedule Item Invoice Item Adjustment | `RevenueScheduleItemInvoiceItemAdjustment` | | Subscription                                  | `Subscription`                             | | Taxable Item Snapshot                         | `TaxableItemSnapshot`                      | | Taxation Item                                 | `TaxationItem`                             | | Updater Batch                                 | `UpdaterBatch`                             | | Usage                                         | `Usage`                                    | 

OpenAPI spec version: 2018-02-27
Contact: docs@zuora.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.0-SNAPSHOT

=end

require 'uri'

module Zuora
  class UsageWithRealTimeRatingApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Delete usage record
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Deletes a usage record. Note that you can only delete usage records with the Pending or Rated status. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage record you want to delete.  
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [DELETEUsageResponseType]
    def d_elete_usage_record(authorization, id, opts = {})
      data, _status_code, _headers = d_elete_usage_record_with_http_info(authorization, id, opts)
      data
    end

    # Delete usage record
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Deletes a usage record. Note that you can only delete usage records with the Pending or Rated status. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage record you want to delete.  
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(DELETEUsageResponseType, Fixnum, Hash)>] DELETEUsageResponseType data, response status code and response headers
    def d_elete_usage_record_with_http_info(authorization, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.d_elete_usage_record ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.d_elete_usage_record"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.d_elete_usage_record"
      end
      # resource path
      local_var_path = '/usage/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'DELETEUsageResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#d_elete_usage_record\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Download usage file template
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Downloads a usage file template.   After the template is downloaded, you can create a usage file based on the template and add usage records to the file.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param file_type The type of the usage file template to be downladed. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [nil]
    def g_et_download_usage_file_template(authorization, file_type, opts = {})
      g_et_download_usage_file_template_with_http_info(authorization, file_type, opts)
      nil
    end

    # Download usage file template
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Downloads a usage file template.   After the template is downloaded, you can create a usage file based on the template and add usage records to the file.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param file_type The type of the usage file template to be downladed. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def g_et_download_usage_file_template_with_http_info(authorization, file_type, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_download_usage_file_template ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_download_usage_file_template"
      end
      # verify the required parameter 'file_type' is set
      if @api_client.config.client_side_validation && file_type.nil?
        fail ArgumentError, "Missing the required parameter 'file_type' when calling UsageWithRealTimeRatingApi.g_et_download_usage_file_template"
      end
      # verify enum value
      if @api_client.config.client_side_validation && !['csv', 'zip'].include?(file_type)
        fail ArgumentError, "invalid value for 'file_type', must be one of csv, zip"
      end
      # resource path
      local_var_path = '/usage-imports/templates/{fileType}'.sub('{' + 'fileType' + '}', file_type.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_download_usage_file_template\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Download usage import failure file
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Downloads the corresponding usage import failure file when a usage file fails to be imported. Usage import failure files are only available for usage import files in COMPLETED_WITH_ERRORS status   The downloaded usage import failure file is in ZIP format, and contains the error information about each usage record failing to be imported.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [nil]
    def g_et_download_usage_import_failure_file(authorization, id, opts = {})
      g_et_download_usage_import_failure_file_with_http_info(authorization, id, opts)
      nil
    end

    # Download usage import failure file
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Downloads the corresponding usage import failure file when a usage file fails to be imported. Usage import failure files are only available for usage import files in COMPLETED_WITH_ERRORS status   The downloaded usage import failure file is in ZIP format, and contains the error information about each usage record failing to be imported.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def g_et_download_usage_import_failure_file_with_http_info(authorization, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_download_usage_import_failure_file ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_download_usage_import_failure_file"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.g_et_download_usage_import_failure_file"
      end
      # resource path
      local_var_path = '/usage-imports/{id}/errors'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/octet-stream'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_download_usage_import_failure_file\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Download usage import file
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Downloads a usage import file with the specified usage import ID.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [nil]
    def g_et_download_usage_import_file(authorization, id, opts = {})
      g_et_download_usage_import_file_with_http_info(authorization, id, opts)
      nil
    end

    # Download usage import file
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Downloads a usage import file with the specified usage import ID.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def g_et_download_usage_import_file_with_http_info(authorization, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_download_usage_import_file ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_download_usage_import_file"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.g_et_download_usage_import_file"
      end
      # resource path
      local_var_path = '/usage-imports/{id}/import-file'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/octet-stream'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_download_usage_import_file\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get rating results by account
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of all the usage charges associated with the specified customer account. The response returns the rating amount of the charges based on billing period.   By default, the response data is displayed in descending order by updated time.  You can specify the date range for which you want to rate in the `fromDate` and `toDate` query parameters. For example: /rated-results/account/*accountNumber*?fromDate=2016-08-01&toDate=2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param account_number The account number. For example, A00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.   You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;        - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:     &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [Date] :to_date The end date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [GetRatedResultsType]
    def g_et_rating_results_by_account(authorization, account_number, opts = {})
      data, _status_code, _headers = g_et_rating_results_by_account_with_http_info(authorization, account_number, opts)
      data
    end

    # Get rating results by account
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of all the usage charges associated with the specified customer account. The response returns the rating amount of the charges based on billing period.   By default, the response data is displayed in descending order by updated time.  You can specify the date range for which you want to rate in the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters. For example: /rated-results/account/*accountNumber*?fromDate&#x3D;2016-08-01&amp;toDate&#x3D;2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param account_number The account number. For example, A00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.   You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;        - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:     &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [Date] :to_date The end date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(GetRatedResultsType, Fixnum, Hash)>] GetRatedResultsType data, response status code and response headers
    def g_et_rating_results_by_account_with_http_info(authorization, account_number, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_rating_results_by_account ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_account"
      end
      # verify the required parameter 'account_number' is set
      if @api_client.config.client_side_validation && account_number.nil?
        fail ArgumentError, "Missing the required parameter 'account_number' when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_account"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_account, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_account, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/rating/rated-results/account/{accountNumber}'.sub('{' + 'accountNumber' + '}', account_number.to_s)

      # query parameters
      query_params = {}
      query_params[:'fromDate'] = opts[:'from_date'] if !opts[:'from_date'].nil?
      query_params[:'toDate'] = opts[:'to_date'] if !opts[:'to_date'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetRatedResultsType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_rating_results_by_account\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get rating results by charge
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of all the usage charges associated with the specified rate plan charge. The rating is based on billing period.  You can specify the date range for which you want to rate in the `fromDate` and `toDate` query parameters. For example: /rated-results/charge/*chargenNumber*?fromDate=2016-08-01&toDate=2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param charge_number The charge number. For example, C-00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.   You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;        - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:     &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [Date] :to_date The end date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [GetRatedResultsType]
    def g_et_rating_results_by_charge(authorization, charge_number, opts = {})
      data, _status_code, _headers = g_et_rating_results_by_charge_with_http_info(authorization, charge_number, opts)
      data
    end

    # Get rating results by charge
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of all the usage charges associated with the specified rate plan charge. The rating is based on billing period.  You can specify the date range for which you want to rate in the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters. For example: /rated-results/charge/*chargenNumber*?fromDate&#x3D;2016-08-01&amp;toDate&#x3D;2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param charge_number The charge number. For example, C-00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.   You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;        - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:     &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [Date] :to_date The end date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(GetRatedResultsType, Fixnum, Hash)>] GetRatedResultsType data, response status code and response headers
    def g_et_rating_results_by_charge_with_http_info(authorization, charge_number, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_rating_results_by_charge ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_charge"
      end
      # verify the required parameter 'charge_number' is set
      if @api_client.config.client_side_validation && charge_number.nil?
        fail ArgumentError, "Missing the required parameter 'charge_number' when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_charge"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_charge, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_charge, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/rating/rated-results/charge/{chargeNumber}'.sub('{' + 'chargeNumber' + '}', charge_number.to_s)

      # query parameters
      query_params = {}
      query_params[:'fromDate'] = opts[:'from_date'] if !opts[:'from_date'].nil?
      query_params[:'toDate'] = opts[:'to_date'] if !opts[:'to_date'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetRatedResultsType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_rating_results_by_charge\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get rating results by subscription
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of all the usage charges associated with the specified subscription. The rating is based on billing period.   You can specify the date range for which you want to rate in the `fromDate` and `toDate` query parameters. For example: /rated-results/subscription/*subscriptionNumber*?fromDate=2016-08-01&toDate=2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param subscription_number The subscription number. For example, A-S00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.    You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;        - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:     &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [Date] :to_date The end date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [GetRatedResultsType]
    def g_et_rating_results_by_subscripiton(authorization, subscription_number, opts = {})
      data, _status_code, _headers = g_et_rating_results_by_subscripiton_with_http_info(authorization, subscription_number, opts)
      data
    end

    # Get rating results by subscription
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of all the usage charges associated with the specified subscription. The rating is based on billing period.   You can specify the date range for which you want to rate in the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters. For example: /rated-results/subscription/*subscriptionNumber*?fromDate&#x3D;2016-08-01&amp;toDate&#x3D;2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param subscription_number The subscription number. For example, A-S00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.    You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;        - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:     &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [Date] :to_date The end date of the date range for which you want to rate. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60; and &#x60;endDate&#x60; &gt; &#x60;fromDate&#x60;  &#x60;startDate&#x60; is the start date of the rating result. &#x60;endDate&#x60; is the end date of the rating result. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(GetRatedResultsType, Fixnum, Hash)>] GetRatedResultsType data, response status code and response headers
    def g_et_rating_results_by_subscripiton_with_http_info(authorization, subscription_number, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_rating_results_by_subscripiton ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_subscripiton"
      end
      # verify the required parameter 'subscription_number' is set
      if @api_client.config.client_side_validation && subscription_number.nil?
        fail ArgumentError, "Missing the required parameter 'subscription_number' when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_subscripiton"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_subscripiton, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_rating_results_by_subscripiton, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/rating/rated-results/subscription/{subscriptionNumber}'.sub('{' + 'subscriptionNumber' + '}', subscription_number.to_s)

      # query parameters
      query_params = {}
      query_params[:'fromDate'] = opts[:'from_date'] if !opts[:'from_date'].nil?
      query_params[:'toDate'] = opts[:'to_date'] if !opts[:'to_date'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetRatedResultsType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_rating_results_by_subscripiton\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get details of usage import
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the detailed information about a specified usage import file. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [GetUsageDetailResponseType]
    def g_et_usage_import_details(authorization, id, opts = {})
      data, _status_code, _headers = g_et_usage_import_details_with_http_info(authorization, id, opts)
      data
    end

    # Get details of usage import
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the detailed information about a specified usage import file. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(GetUsageDetailResponseType, Fixnum, Hash)>] GetUsageDetailResponseType data, response status code and response headers
    def g_et_usage_import_details_with_http_info(authorization, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_import_details ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_import_details"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.g_et_usage_import_details"
      end
      # resource path
      local_var_path = '/usage-imports/{id}/detail'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetUsageDetailResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_import_details\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get status of usage import
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the processing status of a specified usage import file. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [GETUsageImportStatusResponseType]
    def g_et_usage_import_status(authorization, id, opts = {})
      data, _status_code, _headers = g_et_usage_import_status_with_http_info(authorization, id, opts)
      data
    end

    # Get status of usage import
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the processing status of a specified usage import file. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage import. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(GETUsageImportStatusResponseType, Fixnum, Hash)>] GETUsageImportStatusResponseType data, response status code and response headers
    def g_et_usage_import_status_with_http_info(authorization, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_import_status ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_import_status"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.g_et_usage_import_status"
      end
      # resource path
      local_var_path = '/usage-imports/{id}/status'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GETUsageImportStatusResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_import_status\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get usage imports
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the information about all the usage import files, such as the processing status of the usage import files, the total number of usage records that are validated, and the number of usage records with validation errors.   The response is in descending order by the date and time of the `updatedOn` field.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Integer] :page The index number of the page you want to retrieve. By default, the first page is returned in the response.   (default to 0)
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [UsageImports]
    def g_et_usage_imports(authorization, opts = {})
      data, _status_code, _headers = g_et_usage_imports_with_http_info(authorization, opts)
      data
    end

    # Get usage imports
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the information about all the usage import files, such as the processing status of the usage import files, the total number of usage records that are validated, and the number of usage records with validation errors.   The response is in descending order by the date and time of the &#x60;updatedOn&#x60; field.  
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Integer] :page The index number of the page you want to retrieve. By default, the first page is returned in the response.  
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(UsageImports, Fixnum, Hash)>] UsageImports data, response status code and response headers
    def g_et_usage_imports_with_http_info(authorization, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_imports ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_imports"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_imports, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_imports, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/usage-imports'

      # query parameters
      query_params = {}
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'UsageImports')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_imports\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get usage rating by account
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of the usage records associated with the specified customer account. The response returns the rating result of each usage record.  You can specify the date range for which you want to get the usage rating result in the `fromDate` and `toDate` query parameters. For example: /rated-usages/account/*accountNumber*?fromDate=2016-08-01&toDate=2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param account_number The account number. For example, A00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; parameters:     &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [Date] :to_date The end date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [GetRatedUsageResultsType]
    def g_et_usage_rating_by_account(authorization, account_number, opts = {})
      data, _status_code, _headers = g_et_usage_rating_by_account_with_http_info(authorization, account_number, opts)
      data
    end

    # Get usage rating by account
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of the usage records associated with the specified customer account. The response returns the rating result of each usage record.  You can specify the date range for which you want to get the usage rating result in the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters. For example: /rated-usages/account/*accountNumber*?fromDate&#x3D;2016-08-01&amp;toDate&#x3D;2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param account_number The account number. For example, A00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; parameters:     &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [Date] :to_date The end date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(GetRatedUsageResultsType, Fixnum, Hash)>] GetRatedUsageResultsType data, response status code and response headers
    def g_et_usage_rating_by_account_with_http_info(authorization, account_number, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_rating_by_account ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_account"
      end
      # verify the required parameter 'account_number' is set
      if @api_client.config.client_side_validation && account_number.nil?
        fail ArgumentError, "Missing the required parameter 'account_number' when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_account"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_account, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_account, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/rating/rated-usages/account/{accountNumber}'.sub('{' + 'accountNumber' + '}', account_number.to_s)

      # query parameters
      query_params = {}
      query_params[:'fromDate'] = opts[:'from_date'] if !opts[:'from_date'].nil?
      query_params[:'toDate'] = opts[:'to_date'] if !opts[:'to_date'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetRatedUsageResultsType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_rating_by_account\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get usage rating by charge
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of the usage records associated with the specified charge.  The response returns the rating result of each usage record.   You can specify the date range for which you want to get the rating result in the `fromDate` and `toDate` query parameters. For example: /rated-results/charge/*chargenNumber*?fromDate=2016-08-01&toDate=2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param charge_number The charge number. For example, C-00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; parameters:     &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [Date] :to_date The end date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [GetRatedUsageResultsType]
    def g_et_usage_rating_by_charge(authorization, charge_number, opts = {})
      data, _status_code, _headers = g_et_usage_rating_by_charge_with_http_info(authorization, charge_number, opts)
      data
    end

    # Get usage rating by charge
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of the usage records associated with the specified charge.  The response returns the rating result of each usage record.   You can specify the date range for which you want to get the rating result in the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters. For example: /rated-results/charge/*chargenNumber*?fromDate&#x3D;2016-08-01&amp;toDate&#x3D;2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param charge_number The charge number. For example, C-00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; parameters:     &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [Date] :to_date The end date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(GetRatedUsageResultsType, Fixnum, Hash)>] GetRatedUsageResultsType data, response status code and response headers
    def g_et_usage_rating_by_charge_with_http_info(authorization, charge_number, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_rating_by_charge ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_charge"
      end
      # verify the required parameter 'charge_number' is set
      if @api_client.config.client_side_validation && charge_number.nil?
        fail ArgumentError, "Missing the required parameter 'charge_number' when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_charge"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_charge, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_charge, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/rating/rated-usages/charge/{chargeNumber}'.sub('{' + 'chargeNumber' + '}', charge_number.to_s)

      # query parameters
      query_params = {}
      query_params[:'fromDate'] = opts[:'from_date'] if !opts[:'from_date'].nil?
      query_params[:'toDate'] = opts[:'to_date'] if !opts[:'to_date'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetRatedUsageResultsType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_rating_by_charge\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get usage rating by subscription
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of the usage records associated with the specified subscription. The response returns the rating result of each usage record.   You can specify the date range for which you want to get the rating result in the `fromDate` and `toDate` query parameters. For example: /rated-results/subscription/*subscriptionNumber*?fromDate=2016-08-01&toDate=2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param subscription_number The subscription number. For example, A-S00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; parameters:     &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [Date] :to_date The end date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;    - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [GetRatedUsageResultsType]
    def g_et_usage_rating_by_subscription(authorization, subscription_number, opts = {})
      data, _status_code, _headers = g_et_usage_rating_by_subscription_with_http_info(authorization, subscription_number, opts)
      data
    end

    # Get usage rating by subscription
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves the rating result of the usage records associated with the specified subscription. The response returns the rating result of each usage record.   You can specify the date range for which you want to get the rating result in the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters. For example: /rated-results/subscription/*subscriptionNumber*?fromDate&#x3D;2016-08-01&amp;toDate&#x3D;2016-08-21 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param subscription_number The subscription number. For example, A-S00000001. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [Date] :from_date The start date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  You can specify this parameter to restrict the data returned in the response. Make sure you specify a valid date in this query parameter:  - If you only specify the &#x60;fromDate&#x60; query parameter but do not specify the &#x60;toDate&#x60; query parameter:      &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60;       - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; parameters:     &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [Date] :to_date The end date of the date range for which you want to get the rating result. The date must be in &#x60;yyyy-mm-dd&#x60; format. For example, 2007-12-03.  Make sure you specify a valid date in this query parameters: - If you only specify the &#x60;toDate&#x60; query parameter but do not specify the &#x60;fromDate&#x60; query parameter:       &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;    - If you specify both the &#x60;fromDate&#x60; and &#x60;toDate&#x60; query parameters:       &#x60;startDate&#x60; &gt;&#x3D; &#x60;fromDate&#x60; and &#x60;startDate&#x60; &lt;&#x3D; &#x60;toDate&#x60;  &#x60;startDate&#x60; is the start date when the usage is consumed in your tenant time zone. 
    # @option opts [String] :cursor The cursor indicator of the data page you want to retrieve. By default, the first page of data is returned in the response. If more data pages are available, the operation returns &#x60;true&#x60; in the &#x60;hasMore&#x60; response body field. The &#x60;cursor&#x60; response body field specifies the cursor indicator of the next page of data. If there is no data after the current page, the value of &#x60;cursor&#x60; is &#x60;null&#x60;. 
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(GetRatedUsageResultsType, Fixnum, Hash)>] GetRatedUsageResultsType data, response status code and response headers
    def g_et_usage_rating_by_subscription_with_http_info(authorization, subscription_number, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_rating_by_subscription ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_subscription"
      end
      # verify the required parameter 'subscription_number' is set
      if @api_client.config.client_side_validation && subscription_number.nil?
        fail ArgumentError, "Missing the required parameter 'subscription_number' when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_subscription"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_subscription, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_rating_by_subscription, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/rating/rated-usages/subscription/{subscriptionNumber}'.sub('{' + 'subscriptionNumber' + '}', subscription_number.to_s)

      # query parameters
      query_params = {}
      query_params[:'fromDate'] = opts[:'from_date'] if !opts[:'from_date'].nil?
      query_params[:'toDate'] = opts[:'to_date'] if !opts[:'to_date'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GetRatedUsageResultsType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_rating_by_subscription\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get usage record
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves information about a specific usage record. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage record you want to retrieve.  
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [GETUsageResponseType]
    def g_et_usage_record(authorization, id, opts = {})
      data, _status_code, _headers = g_et_usage_record_with_http_info(authorization, id, opts)
      data
    end

    # Get usage record
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves information about a specific usage record. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage record you want to retrieve.  
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(GETUsageResponseType, Fixnum, Hash)>] GETUsageResponseType data, response status code and response headers
    def g_et_usage_record_with_http_info(authorization, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_record ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_record"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.g_et_usage_record"
      end
      # resource path
      local_var_path = '/usage/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'GETUsageResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_record\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Query usage records
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves information about usage records.   You can specify certain response fields you want to retrieve by specifying the `fields` and `filters` query parameters. By default, all the response fields are returned in the response. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [String] :fields The fields of the usage records you want to retrieve. By default, all the fields in the **Responses** section are returned.  Use commas to separate the field names. You can specify any fields described in the **Responses** section. For example: &#x60;/usage/query?fields&#x3D;tag,quantity,id&#x60; 
    # @option opts [String] :filters This parameter restricts the data returned in the response. You can use this parameter to supply a dimension you want to filter on.  A single filter uses the following form:   *field_name* *operator* *field_value*  Supported operators: &#x60;&#x3D;&#x60;, &#x60;!&#x3D;&#x60;, &#x60;&gt;&#x60;, &#x60;&lt;&#x60;, &#x60;&gt;&#x3D;&#x60;, &#x60;&lt;&#x3D;&#x60;, &#x60;IS NULL&#x60;, &#x60;IS NOT NULL&#x60;, &#x60;IN&#x60; (The letters are not case sensitive.)  You can specify any fields except for the custom fields described in the **Responses** section. Filters can be combined using the &#x60;AND&#x60; boolean logic. For example: *field_name* *operator* *field_value* AND *field_name* *operator* *field_value*  Currently, the fields in filters must include at least one of the following fields: &#x60;accountNumber&#x60;, &#x60;unitOfMeasure&#x60;, &#x60;status&#x60;, &#x60;uniqueKey&#x60;, and &#x60;updatedOn&#x60;.   Examples:  - /usage/query?filters&#x3D; (id &#x3D;&#39;035e35bd-880a-47c9-99df-830143b13aed&#39; AND status&#x3D;&#39;Pending&#39;)  - /usage/query?fields&#x3D;tag,id&amp;filters&#x3D; (quantity &gt; 10 AND unitOfMeasure &#x3D; &#39;GB&#39;)  - /usage/query?filters&#x3D;(status in (&#39;Pending&#39;,&#39;Rated&#39;)) 
    # @option opts [Integer] :page The index number of the page you want to retrieve. By default, the first page is returned in the response.   (default to 0)
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.   (default to 100)
    # @return [QueryUsageResponseType]
    def g_et_usage_records_query(authorization, opts = {})
      data, _status_code, _headers = g_et_usage_records_query_with_http_info(authorization, opts)
      data
    end

    # Query usage records
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves information about usage records.   You can specify certain response fields you want to retrieve by specifying the &#x60;fields&#x60; and &#x60;filters&#x60; query parameters. By default, all the response fields are returned in the response. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [String] :fields The fields of the usage records you want to retrieve. By default, all the fields in the **Responses** section are returned.  Use commas to separate the field names. You can specify any fields described in the **Responses** section. For example: &#x60;/usage/query?fields&#x3D;tag,quantity,id&#x60; 
    # @option opts [String] :filters This parameter restricts the data returned in the response. You can use this parameter to supply a dimension you want to filter on.  A single filter uses the following form:   *field_name* *operator* *field_value*  Supported operators: &#x60;&#x3D;&#x60;, &#x60;!&#x3D;&#x60;, &#x60;&gt;&#x60;, &#x60;&lt;&#x60;, &#x60;&gt;&#x3D;&#x60;, &#x60;&lt;&#x3D;&#x60;, &#x60;IS NULL&#x60;, &#x60;IS NOT NULL&#x60;, &#x60;IN&#x60; (The letters are not case sensitive.)  You can specify any fields except for the custom fields described in the **Responses** section. Filters can be combined using the &#x60;AND&#x60; boolean logic. For example: *field_name* *operator* *field_value* AND *field_name* *operator* *field_value*  Currently, the fields in filters must include at least one of the following fields: &#x60;accountNumber&#x60;, &#x60;unitOfMeasure&#x60;, &#x60;status&#x60;, &#x60;uniqueKey&#x60;, and &#x60;updatedOn&#x60;.   Examples:  - /usage/query?filters&#x3D; (id &#x3D;&#39;035e35bd-880a-47c9-99df-830143b13aed&#39; AND status&#x3D;&#39;Pending&#39;)  - /usage/query?fields&#x3D;tag,id&amp;filters&#x3D; (quantity &gt; 10 AND unitOfMeasure &#x3D; &#39;GB&#39;)  - /usage/query?filters&#x3D;(status in (&#39;Pending&#39;,&#39;Rated&#39;)) 
    # @option opts [Integer] :page The index number of the page you want to retrieve. By default, the first page is returned in the response.  
    # @option opts [Integer] :page_size The maximum number of rows in a page to return in a response.  
    # @return [Array<(QueryUsageResponseType, Fixnum, Hash)>] QueryUsageResponseType data, response status code and response headers
    def g_et_usage_records_query_with_http_info(authorization, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_records_query ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_records_query"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 2000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_records_query, must be smaller than or equal to 2000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 25
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling UsageWithRealTimeRatingApi.g_et_usage_records_query, must be greater than or equal to 25.'
      end

      # resource path
      local_var_path = '/usage/query'

      # query parameters
      query_params = {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filters'] = opts[:'filters'] if !opts[:'filters'].nil?
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'pageSize'] = opts[:'page_size'] if !opts[:'page_size'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'QueryUsageResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_records_query\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Query usage records in stream
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves information about usage records in a stream without pagination.   You can specify certain response fields you want to retrieve by sepcifying the `fields` and `filters` query parameters. By default, all the reponse fields are returned in the response. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [String] :fields The fields of the usage records you want to retrieve. By default, all the fields in the **Responses** section are returned.  Use commas to separate the field names. You can specify any fields described in the **Responses** section. For example: &#x60;/usage/stream-query?fields&#x3D;tag,quantity,id,customFields.age&#x60; 
    # @option opts [String] :filters This parameter restricts the data returned in the response. You can use this parameter to supply a dimension you want to filter on.  A single filter uses the following form:   *field_name* *operator* *field_value*  Supported operators: &#x60;&#x3D;&#x60;, &#x60;!&#x3D;&#x60;, &#x60;&gt;&#x60;, &#x60;&lt;&#x60;, &#x60;&gt;&#x3D;&#x60;, &#x60;&lt;&#x3D;&#x60;, &#x60;IS NULL&#x60;, &#x60;IS NOT NULL&#x60;, &#x60;IN&#x60; (The letters are not case sensitive.)  You can specify any fields, including the custom fields, described in the **Responses** section. Filters can be combined using the &#x60;AND&#x60; boolean logic. For example: *field_name* *operator* *field_value* AND *field_name* *operator* *field_value*  Currently, the fields in filters must include at least one of the following fields: &#x60;accountNumber&#x60;, &#x60;unitOfMeasure&#x60;, &#x60;status&#x60;, &#x60;uniqueKey&#x60;, and &#x60;updatedOn&#x60;.   Examples:  - /usage/stream-query?filters&#x3D; (id &#x3D;&#39;035e35bd-880a-47c9-99df-830143b13aed&#39; AND status&#x3D;&#39;Pending&#39; AND customFields.age&#x3D;20)  - /usage/stream-query?fields&#x3D;tag,id&amp;filters&#x3D; (quantity &gt; 10 AND unitOfMeasure &#x3D; &#39;GB&#39;)  - /usage/stream-query?filters&#x3D;(status in (&#39;Pending&#39;,&#39;Rated&#39;)) 
    # @return [QueryUsageResponseType]
    def g_et_usage_records_stream_query(authorization, opts = {})
      data, _status_code, _headers = g_et_usage_records_stream_query_with_http_info(authorization, opts)
      data
    end

    # Query usage records in stream
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Retrieves information about usage records in a stream without pagination.   You can specify certain response fields you want to retrieve by sepcifying the &#x60;fields&#x60; and &#x60;filters&#x60; query parameters. By default, all the reponse fields are returned in the response. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [String] :fields The fields of the usage records you want to retrieve. By default, all the fields in the **Responses** section are returned.  Use commas to separate the field names. You can specify any fields described in the **Responses** section. For example: &#x60;/usage/stream-query?fields&#x3D;tag,quantity,id,customFields.age&#x60; 
    # @option opts [String] :filters This parameter restricts the data returned in the response. You can use this parameter to supply a dimension you want to filter on.  A single filter uses the following form:   *field_name* *operator* *field_value*  Supported operators: &#x60;&#x3D;&#x60;, &#x60;!&#x3D;&#x60;, &#x60;&gt;&#x60;, &#x60;&lt;&#x60;, &#x60;&gt;&#x3D;&#x60;, &#x60;&lt;&#x3D;&#x60;, &#x60;IS NULL&#x60;, &#x60;IS NOT NULL&#x60;, &#x60;IN&#x60; (The letters are not case sensitive.)  You can specify any fields, including the custom fields, described in the **Responses** section. Filters can be combined using the &#x60;AND&#x60; boolean logic. For example: *field_name* *operator* *field_value* AND *field_name* *operator* *field_value*  Currently, the fields in filters must include at least one of the following fields: &#x60;accountNumber&#x60;, &#x60;unitOfMeasure&#x60;, &#x60;status&#x60;, &#x60;uniqueKey&#x60;, and &#x60;updatedOn&#x60;.   Examples:  - /usage/stream-query?filters&#x3D; (id &#x3D;&#39;035e35bd-880a-47c9-99df-830143b13aed&#39; AND status&#x3D;&#39;Pending&#39; AND customFields.age&#x3D;20)  - /usage/stream-query?fields&#x3D;tag,id&amp;filters&#x3D; (quantity &gt; 10 AND unitOfMeasure &#x3D; &#39;GB&#39;)  - /usage/stream-query?filters&#x3D;(status in (&#39;Pending&#39;,&#39;Rated&#39;)) 
    # @return [Array<(QueryUsageResponseType, Fixnum, Hash)>] QueryUsageResponseType data, response status code and response headers
    def g_et_usage_records_stream_query_with_http_info(authorization, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.g_et_usage_records_stream_query ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.g_et_usage_records_stream_query"
      end
      # resource path
      local_var_path = '/usage/stream-query'

      # query parameters
      query_params = {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filters'] = opts[:'filters'] if !opts[:'filters'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'QueryUsageResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#g_et_usage_records_stream_query\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Import usage file
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Imports usage data by uploading a usage file in CSV or ZIP format.   The maximum size of a usage file in CSV or ZIP format to be uploaded is 20 MB. If the size of a usage file exceeds 20 MB, zip the usage file before uploading it. One ZIP file can only contain one CSV file.   For more information about the usage file format, see [Usage Data Import](https://knowledgecenter.zuora.com/CB_Billing/J_Billing_Operations/Real-Time_Usage_Rating/Usage_Data_Import). 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param file The path and name of the usage file to be imported. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [String] :description The description of the usage file to be imported. 
    # @return [POSTUsageImportResponseType]
    def p_ost_import_usage_file(authorization, file, opts = {})
      data, _status_code, _headers = p_ost_import_usage_file_with_http_info(authorization, file, opts)
      data
    end

    # Import usage file
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Imports usage data by uploading a usage file in CSV or ZIP format.   The maximum size of a usage file in CSV or ZIP format to be uploaded is 20 MB. If the size of a usage file exceeds 20 MB, zip the usage file before uploading it. One ZIP file can only contain one CSV file.   For more information about the usage file format, see [Usage Data Import](https://knowledgecenter.zuora.com/CB_Billing/J_Billing_Operations/Real-Time_Usage_Rating/Usage_Data_Import). 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param file The path and name of the usage file to be imported. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @option opts [String] :description The description of the usage file to be imported. 
    # @return [Array<(POSTUsageImportResponseType, Fixnum, Hash)>] POSTUsageImportResponseType data, response status code and response headers
    def p_ost_import_usage_file_with_http_info(authorization, file, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.p_ost_import_usage_file ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.p_ost_import_usage_file"
      end
      # verify the required parameter 'file' is set
      if @api_client.config.client_side_validation && file.nil?
        fail ArgumentError, "Missing the required parameter 'file' when calling UsageWithRealTimeRatingApi.p_ost_import_usage_file"
      end
      # resource path
      local_var_path = '/usage-imports'

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['multipart/form-data'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}
      form_params['file'] = file
      form_params['description'] = opts[:'description'] if !opts[:'description'].nil?

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'POSTUsageImportResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#p_ost_import_usage_file\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create usage records
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Creates a single or multiple usage records. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param content_type The type of the request content.   - If you create multiple usage records, you must specify the value of this parameter to &#x60;application/vnd.zuora.usage-bulk+json&#x60;.    - If you create a single usage record, you do not need to specify this field. 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [POSTUsageRecordResponseType]
    def p_ost_usage_records(authorization, content_type, body, opts = {})
      data, _status_code, _headers = p_ost_usage_records_with_http_info(authorization, content_type, body, opts)
      data
    end

    # Create usage records
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Creates a single or multiple usage records. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param content_type The type of the request content.   - If you create multiple usage records, you must specify the value of this parameter to &#x60;application/vnd.zuora.usage-bulk+json&#x60;.    - If you create a single usage record, you do not need to specify this field. 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(POSTUsageRecordResponseType, Fixnum, Hash)>] POSTUsageRecordResponseType data, response status code and response headers
    def p_ost_usage_records_with_http_info(authorization, content_type, body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.p_ost_usage_records ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.p_ost_usage_records"
      end
      # verify the required parameter 'content_type' is set
      if @api_client.config.client_side_validation && content_type.nil?
        fail ArgumentError, "Missing the required parameter 'content_type' when calling UsageWithRealTimeRatingApi.p_ost_usage_records"
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling UsageWithRealTimeRatingApi.p_ost_usage_records"
      end
      # resource path
      local_var_path = '/usage'

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/vnd.zuora.usage-bulk+json;charset=UTF-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Content-Type'] = content_type
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(body)
      auth_names = []
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'POSTUsageRecordResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#p_ost_usage_records\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update usage record
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Updates certain information of a specified usage record. Note that you can only update usage records that are not billed. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage record you want to update.  
    # @param body 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [PUTUpdateUsageResponseType]
    def p_ut_usage_record(authorization, id, body, opts = {})
      data, _status_code, _headers = p_ut_usage_record_with_http_info(authorization, id, body, opts)
      data
    end

    # Update usage record
    # **Note:** The Real-Time Usage Rating feature is in **Limited Availability**. If you wish to have access to the feature, submit a request at [Zuora Global Support](http://support.zuora.com/).  Updates certain information of a specified usage record. Note that you can only update usage records that are not billed. 
    # @param authorization &#x60;Bearer {token}&#x60; for a valid OAuth token. 
    # @param id The ID of the usage record you want to update.  
    # @param body 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :zuora_entity_ids An entity ID. If you have [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity) enabled and the OAuth token is valid for more than one entity, you must use this header to specify which entity to perform the operation in. If the OAuth token is only valid for a single entity, or you do not have Zuora Multi-entity enabled, you do not need to set this header. 
    # @option opts [String] :zuora_request_id A request ID for tracking the API call. If you specify a value for this header, Zuora returns the same value in the response headers. If you do not specify a value for this header, Zuora provides a request ID in the response headers. 
    # @return [Array<(PUTUpdateUsageResponseType, Fixnum, Hash)>] PUTUpdateUsageResponseType data, response status code and response headers
    def p_ut_usage_record_with_http_info(authorization, id, body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: UsageWithRealTimeRatingApi.p_ut_usage_record ...'
      end
      # verify the required parameter 'authorization' is set
      if @api_client.config.client_side_validation && authorization.nil?
        fail ArgumentError, "Missing the required parameter 'authorization' when calling UsageWithRealTimeRatingApi.p_ut_usage_record"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling UsageWithRealTimeRatingApi.p_ut_usage_record"
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling UsageWithRealTimeRatingApi.p_ut_usage_record"
      end
      # resource path
      local_var_path = '/usage/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json; charset=utf-8'])
      header_params[:'Authorization'] = authorization
      header_params[:'Zuora-Entity-Ids'] = opts[:'zuora_entity_ids'] if !opts[:'zuora_entity_ids'].nil?
      header_params[:'Zuora-Request-Id'] = opts[:'zuora_request_id'] if !opts[:'zuora_request_id'].nil?

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(body)
      auth_names = []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'PUTUpdateUsageResponseType')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: UsageWithRealTimeRatingApi#p_ut_usage_record\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
