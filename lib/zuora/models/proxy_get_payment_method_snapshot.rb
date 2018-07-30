=begin
#Zuora API Reference

#  # Introduction Welcome to the reference for the Zuora REST API!  <a href=\"http://en.wikipedia.org/wiki/REST_API\" target=\"_blank\">REST</a> is a web-service protocol that lends itself to rapid development by using everyday HTTP and JSON technology.  The Zuora REST API provides a broad set of operations and resources that:    * Enable Web Storefront integration from your website.   * Support self-service subscriber sign-ups and account management.   * Process revenue schedules through custom revenue rule models.   * Enable manipulation of most objects in the Zuora Object Model.  Want to share your opinion on how our API works for you? <a href=\"https://community.zuora.com/t5/Developers/API-Feedback-Form/gpm-p/21399\" target=\"_blank\">Tell us how you feel </a>about using our API and what we can do to make it better.    ## Endpoints      The Zuora REST API is provided via the following endpoints.   | Tenant              | Base URL for REST Endpoints |   |-------------------------|-------------------------|   |US Production | https://rest.zuora.com   |   |US API Sandbox    | https://rest.apisandbox.zuora.com|   |US Performance Test | https://rest.pt1.zuora.com |   |EU Production | https://rest.eu.zuora.com |   |EU Sandbox | https://rest.sandbox.eu.zuora.com |      The production endpoint provides access to your live user data. The API Sandbox tenant is a good place to test your code without affecting real-world data. To use it, you must be provisioned with an API Sandbox tenant - your Zuora representative can help you if needed.      ## Access to the API      If you have a Zuora tenant, you already have access to the API.      If you don't have a Zuora tenant, go to <a href=\" https://www.zuora.com/resource/zuora-test-drive\" target=\"_blank\">https://www.zuora.com/resource/zuora-test-drive</a> and sign up for a Production Test Drive tenant. The tenant comes with seed data, such as a sample product catalog.  We recommend that you <a href=\"https://knowledgecenter.zuora.com/CF_Users_and_Administrators/A_Administrator_Settings/Manage_Users/Create_an_API_User\" target=\"_blank\">create an API user</a> specifically for making API calls. Don't log in to the Zuora UI with this account. Logging in to the UI enables a security feature that periodically expires the account's password, which may eventually cause authentication failures with the API. Note that a user role does not have write access to Zuora REST services unless it has the API Write Access permission as described in those instructions.   # API Changelog You can find the <a href=\"https://community.zuora.com/t5/Developers/API-Changelog/gpm-p/18092\" target=\"_blank\">Changelog</a> of the API Reference in the Zuora Community.   # Authentication  ## OAuth v2.0  Zuora recommends that you use OAuth v2.0 to authenticate to the Zuora REST API. Currently, OAuth is not available in every environment. See [Zuora Testing Environments](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/D_Zuora_Environments) for more information.  Zuora recommends you to create a dedicated API user with API write access on a tenant when authenticating via OAuth, and then create an OAuth client for this user. By doing this, you can control permissions of the API user without affecting other non-API users. Note that if a user is deactivated, all his OAuth clients will be automatically deactivated.  Authenticating via OAuth requires the following steps: 1. Create a Client 2. Generate a Token 3. Make Authenticated Requests  ### Create a Client  You must first [create an OAuth client](https://knowledgecenter.zuora.com/CF_Users_and_Administrators/A_Administrator_Settings/Manage_Users#Create_an_OAuth_Client_for_a_User) in the Zuora UI. To do this, you must be an administrator of your Zuora tenant. This is a one-time operation. You will be provided with a Client ID and a Client Secret. Please note this information down, as it will be required for the next step.  **Note:** The OAuth client will be owned by a Zuora user account. If you want to perform PUT, POST, or DELETE operations using the OAuth client, the owner of the OAuth client must have a Platform role that includes the \"API Write Access\" permission.  ### Generate a Token  After creating a client, you must make a call to obtain a bearer token using the [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) operation. This operation requires the following parameters: - `client_id` - the Client ID displayed when you created the OAuth client in the previous step - `client_secret` - the Client Secret displayed when you created the OAuth client in the previous step - `grant_type` - must be set to `client_credentials`  **Note**: The Client ID and Client Secret mentioned above were displayed when you created the OAuth Client in the prior step. The [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) response specifies how long the bearer token is valid for. Call [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) again to generate a new bearer token.  ### Make Authenticated Requests  To authenticate subsequent API requests, you must provide a valid bearer token in an HTTP header:  `Authorization: Bearer {bearer_token}`  If you have [Zuora Multi-entity](https://www.zuora.com/developer/api-reference/#tag/Entities) enabled, you need to set an additional header to specify the ID of the entity that you want to access. You can use the `scope` field in the [Generate an OAuth token](https://www.zuora.com/developer/api-reference/#operation/createToken) response to determine whether you need to specify an entity ID.  If the `scope` field contains more than one entity ID, you must specify the ID of the entity that you want to access. For example, if the `scope` field contains `entity.1a2b7a37-3e7d-4cb3-b0e2-883de9e766cc` and `entity.c92ed977-510c-4c48-9b51-8d5e848671e9`, specify one of the following headers: - `Zuora-Entity-Ids: 1a2b7a37-3e7d-4cb3-b0e2-883de9e766cc` - `Zuora-Entity-Ids: c92ed977-510c-4c48-9b51-8d5e848671e9`  **Note**: For a limited period of time, Zuora will accept the `entityId` header as an alternative to the `Zuora-Entity-Ids` header. If you choose to set the `entityId` header, you must remove all \"-\" characters from the entity ID in the `scope` field.  If the `scope` field contains a single entity ID, you do not need to specify an entity ID.   ## Other Supported Authentication Schemes  Zuora continues to support the following additional legacy means of authentication:    * Use username and password. Include authentication with each request in the header:         * `apiAccessKeyId`      * `apiSecretAccessKey`    * Use an authorization cookie. The cookie authorizes the user to make calls to the REST API for the duration specified in  **Administration > Security Policies > Session timeout**. The cookie expiration time is reset with this duration after every call to the REST API. To obtain a cookie, call the [Connections](https://www.zuora.com/developer/api-reference/#tag/Connections) resource with the following API user information:         *   ID         *   password        * For CORS-enabled APIs only: Include a 'single-use' token in the request header, which re-authenticates the user with each request. See below for more details.  ### Entity Id and Entity Name  The `entityId` and `entityName` parameters are only used for [Zuora Multi-entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity \"Zuora Multi-entity\"). These are the legacy parameters that Zuora will only continue to support for a period of time. Zuora recommends you to use the `Zuora-Entity-Ids` parameter instead.   The  `entityId` and `entityName` parameters specify the Id and the [name of the entity](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity/B_Introduction_to_Entity_and_Entity_Hierarchy#Name_and_Display_Name \"Introduction to Entity and Entity Hierarchy\") that you want to access, respectively. Note that you must have permission to access the entity.   You can specify either the `entityId` or `entityName` parameter in the authentication to access and view an entity.    * If both `entityId` and `entityName` are specified in the authentication, an error occurs.    * If neither `entityId` nor `entityName` is specified in the authentication, you will log in to the entity in which your user account is created.      To get the entity Id and entity name, you can use the GET Entities REST call. For more information, see [API User Authentication](https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Multi-entity/A_Overview_of_Multi-entity#API_User_Authentication \"API User Authentication\").      ### Token Authentication for CORS-Enabled APIs      The CORS mechanism enables REST API calls to Zuora to be made directly from your customer's browser, with all credit card and security information transmitted directly to Zuora. This minimizes your PCI compliance burden, allows you to implement advanced validation on your payment forms, and  makes your payment forms look just like any other part of your website.    For security reasons, instead of using cookies, an API request via CORS uses **tokens** for authentication.  The token method of authentication is only designed for use with requests that must originate from your customer's browser; **it should  not be considered a replacement to the existing cookie authentication** mechanism.  See [Zuora CORS REST](https://knowledgecenter.zuora.com/DC_Developers/REST_API/A_REST_basics/G_CORS_REST \"Zuora CORS REST\") for details on how CORS works and how you can begin to implement customer calls to the Zuora REST APIs. See  [HMAC Signatures](https://www.zuora.com/developer/api-reference/#operation/POSTHMACSignature \"HMAC Signatures\") for details on the HMAC method that returns the authentication token.  # Requests and Responses  ## Request IDs  As a general rule, when asked to supply a \"key\" for an account or subscription (accountKey, account-key, subscriptionKey, subscription-key), you can provide either the actual ID or  the number of the entity.  ## HTTP Request Body  Most of the parameters and data accompanying your requests will be contained in the body of the HTTP request.   The Zuora REST API accepts JSON in the HTTP request body. No other data format (e.g., XML) is supported.  ### Data Type  ([Actions](https://www.zuora.com/developer/api-reference/#tag/Actions) and CRUD operations only) We recommend that you do not specify the decimal values with quotation marks, commas, and spaces. Use characters of `+-0-9.eE`, for example, `5`, `1.9`, `-8.469`, and `7.7e2`. Also, Zuora does not convert currencies for decimal values.  ## Testing a Request  Use a third party client, such as [curl](https://curl.haxx.se \"curl\"), [Postman](https://www.getpostman.com \"Postman\"), or [Advanced REST Client](https://advancedrestclient.com \"Advanced REST Client\"), to test the Zuora REST API.  You can test the Zuora REST API from the Zuora API Sandbox or Production tenants. If connecting to Production, bear in mind that you are working with your live production data, not sample data or test data.  ## Testing with Credit Cards  Sooner or later it will probably be necessary to test some transactions that involve credit cards. For suggestions on how to handle this, see [Going Live With Your Payment Gateway](https://knowledgecenter.zuora.com/CB_Billing/M_Payment_Gateways/C_Managing_Payment_Gateways/B_Going_Live_Payment_Gateways#Testing_with_Credit_Cards \"C_Zuora_User_Guides/A_Billing_and_Payments/M_Payment_Gateways/C_Managing_Payment_Gateways/B_Going_Live_Payment_Gateways#Testing_with_Credit_Cards\" ).  ## Concurrent Request Limits  Zuora enforces tenant-level concurrent request limits. See <a href=\"https://knowledgecenter.zuora.com/BB_Introducing_Z_Business/Policies/Concurrent_Request_Limits\" target=\"_blank\">Concurrent Request Limits</a> for more information.    ## Error Handling  Responses and error codes are detailed in [Responses and errors](https://knowledgecenter.zuora.com/DC_Developers/REST_API/A_REST_basics/3_Responses_and_errors \"Responses and errors\").  # Pagination  When retrieving information (using GET methods), the optional `pageSize` query parameter sets the maximum number of rows to return in a response. The maximum is `40`; larger values are treated as `40`. If this value is empty or invalid, `pageSize` typically defaults to `10`.  The default value for the maximum number of rows retrieved can be overridden at the method level.  If more rows are available, the response will include a `nextPage` element, which contains a URL for requesting the next page.  If this value is not provided, no more rows are available. No \"previous page\" element is explicitly provided; to support backward paging, use the previous call.  ## Array Size  For data items that are not paginated, the REST API supports arrays of up to 300 rows.  Thus, for instance, repeated pagination can retrieve thousands of customer accounts, but within any account an array of no more than 300 rate plans is returned.  # API Versions  The Zuora REST API are version controlled. Versioning ensures that Zuora REST API changes are backward compatible. Zuora uses a major and minor version nomenclature to manage changes. By specifying a version in a REST request, you can get expected responses regardless of future changes to the API.  ## Major Version  The major version number of the REST API appears in the REST URL. Currently, Zuora only supports the **v1** major version. For example, `POST https://rest.zuora.com/v1/subscriptions`.  ## Minor Version  Zuora uses minor versions for the REST API to control small changes. For example, a field in a REST method is deprecated and a new field is used to replace it.   Some fields in the REST methods are supported as of minor versions. If a field is not noted with a minor version, this field is available for all minor versions. If a field is noted with a minor version, this field is in version control. You must specify the supported minor version in the request header to process without an error.   If a field is in version control, it is either with a minimum minor version or a maximum minor version, or both of them. You can only use this field with the minor version between the minimum and the maximum minor versions. For example, the `invoiceCollect` field in the POST Subscription method is in version control and its maximum minor version is 189.0. You can only use this field with the minor version 189.0 or earlier.  If you specify a version number in the request header that is not supported, Zuora will use the minimum minor version of the REST API. In our REST API documentation, if a field or feature requires a minor version number, we note that in the field description.  You only need to specify the version number when you use the fields require a minor version. To specify the minor version, set the `zuora-version` parameter to the minor version number in the request header for the request call. For example, the `collect` field is in 196.0 minor version. If you want to use this field for the POST Subscription method, set the  `zuora-version` parameter to `196.0` in the request header. The `zuora-version` parameter is case sensitive.  For all the REST API fields, by default, if the minor version is not specified in the request header, Zuora will use the minimum minor version of the REST API to avoid breaking your integration.   ### Minor Version History  The supported minor versions are not serial. This section documents the changes made to each Zuora REST API minor version.  The following table lists the supported versions and the fields that have a Zuora REST API minor version.  | Fields         | Minor Version      | REST Methods    | Description | |:--------|:--------|:--------|:--------| | invoiceCollect | 189.0 and earlier  | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Generates an invoice and collects a payment for a subscription. | | collect        | 196.0 and later    | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Collects an automatic payment for a subscription. | | invoice | 196.0 and 207.0| [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Generates an invoice for a subscription. | | invoiceTargetDate | 196.0 and earlier  | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\") |Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | invoiceTargetDate | 207.0 and earlier  | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | targetDate | 207.0 and later | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\") |Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | targetDate | 211.0 and later | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Date through which charges are calculated on the invoice, as `yyyy-mm-dd`. | | includeExisting DraftInvoiceItems | 196.0 and earlier| [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | Specifies whether to include draft invoice items in subscription previews. Specify it to be `true` (default) to include draft invoice items in the preview result. Specify it to be `false` to excludes draft invoice items in the preview result. | | includeExisting DraftDocItems | 207.0 and later  | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | Specifies whether to include draft invoice items in subscription previews. Specify it to be `true` (default) to include draft invoice items in the preview result. Specify it to be `false` to excludes draft invoice items in the preview result. | | previewType | 196.0 and earlier| [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | The type of preview you will receive. The possible values are `InvoiceItem`(default), `ChargeMetrics`, and `InvoiceItemChargeMetrics`. | | previewType | 207.0 and later  | [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") | The type of preview you will receive. The possible values are `LegalDoc`(default), `ChargeMetrics`, and `LegalDocChargeMetrics`. | | runBilling  | 211.0 and later  | [Create Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_Subscription \"Create Subscription\"); [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\"); [Renew Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_RenewSubscription \"Renew Subscription\"); [Cancel Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_CancelSubscription \"Cancel Subscription\"); [Suspend Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_SuspendSubscription \"Suspend Subscription\"); [Resume Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_ResumeSubscription \"Resume Subscription\"); [Create Account](https://www.zuora.com/developer/api-reference/#operation/POST_Account \"Create Account\")|Generates an invoice or credit memo for a subscription. **Note:** Credit memos are only available if you have the Advanced AR Settlement feature enabled. | | invoiceDate | 214.0 and earlier  | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date that should appear on the invoice being generated, as `yyyy-mm-dd`. | | invoiceTargetDate | 214.0 and earlier  | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date through which to calculate charges on this account if an invoice is generated, as `yyyy-mm-dd`. | | documentDate | 215.0 and later | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date that should appear on the invoice and credit memo being generated, as `yyyy-mm-dd`. | | targetDate | 215.0 and later | [Invoice and Collect](https://www.zuora.com/developer/api-reference/#operation/POST_TransactionInvoicePayment \"Invoice and Collect\") |Date through which to calculate charges on this account if an invoice or a credit memo is generated, as `yyyy-mm-dd`. |  #### Version 207.0 and Later  The response structure of the [Preview Subscription](https://www.zuora.com/developer/api-reference/#operation/POST_SubscriptionPreview \"Preview Subscription\") and [Update Subscription](https://www.zuora.com/developer/api-reference/#operation/PUT_Subscription \"Update Subscription\") methods are changed. The following invoice related response fields are moved to the invoice container:    * amount   * amountWithoutTax   * taxAmount   * invoiceItems   * targetDate   * chargeMetrics  # Zuora Object Model  The following diagram presents a high-level view of the key Zuora objects. Click the image to open it in a new tab to resize it.  <a href=\"https://www.zuora.com/wp-content/uploads/2017/01/ZuoraERD.jpeg\" target=\"_blank\"><img src=\"https://www.zuora.com/wp-content/uploads/2017/01/ZuoraERD.jpeg\" alt=\"Zuora Object Model Diagram\"></a>  You can use the [Describe object](https://www.zuora.com/developer/api-reference/#operation/GET_Describe) operation to list the fields of each Zuora object that is available in your tenant. When you call the operation, you must specify the API name of the Zuora object.  The following table provides the API name of each Zuora object:  | Object                                        | API Name                                   | |-----------------------------------------------|--------------------------------------------| | Account                                       | `Account`                                  | | Accounting Code                               | `AccountingCode`                           | | Accounting Period                             | `AccountingPeriod`                         | | Amendment                                     | `Amendment`                                | | Application Group                             | `ApplicationGroup`                         | | Billing Run                                   | `BillRun`                               | | Contact                                       | `Contact`                                  | | Contact Snapshot                              | `ContactSnapshot`                          | | Credit Balance Adjustment                     | `CreditBalanceAdjustment`                  | | Credit Memo                                   | `CreditMemo`                               | | Credit Memo Application                       | `CreditMemoApplication`                    | | Credit Memo Application Item                  | `CreditMemoApplicationItem`                | | Credit Memo Item                              | `CreditMemoItem`                           | | Credit Memo Part                              | `CreditMemoPart`                           | | Credit Memo Part Item                         | `CreditMemoPartItem`                       | | Credit Taxation Item                          | `CreditTaxationItem`                       | | Custom Exchange Rate                          | `FXCustomRate`                             | | Debit Memo                                    | `DebitMemo`                                | | Debit Memo Item                               | `DebitMemoItem`                            | | Debit Taxation Item                           | `DebitTaxationItem`                        | | Discount Applied Metrics                      | `DiscountAppliedMetrics`                   | | Entity                                        | `Tenant`                                   | | Gateway Reconciliation Event                  | `PaymentGatewayReconciliationEventLog`     | | Gateway Reconciliation Job                    | `PaymentReconciliationJob`                 | | Gateway Reconciliation Log                    | `PaymentReconciliationLog`                 | | Invoice                                       | `Invoice`                                  | | Invoice Adjustment                            | `InvoiceAdjustment`                        | | Invoice Item                                  | `InvoiceItem`                              | | Invoice Item Adjustment                       | `InvoiceItemAdjustment`                    | | Invoice Payment                               | `InvoicePayment`                           | | Journal Entry                                 | `JournalEntry`                             | | Journal Entry Item                            | `JournalEntryItem`                         | | Journal Run                                   | `JournalRun`                               | | Order                                         | `Order`                                    | | Order Action                                  | `OrderAction`                              | | Order MRR                                     | `OrderMrr`                                 | | Order Quantity                                | `OrderQuantity`                            | | Order TCB                                     | `OrderTcb`                                 | | Order TCV                                     | `OrderTcv`                                 | | Payment                                       | `Payment`                                  | | Payment Application                           | `PaymentApplication`                       | | Payment Application Item                      | `PaymentApplicationItem`                   | | Payment Method                                | `PaymentMethod`                            | | Payment Method Snapshot                       | `PaymentMethodSnapshot`                    | | Payment Method Transaction Log                | `PaymentMethodTransactionLog`              | | Payment Method Update                         | `UpdaterDetail`                            | | Payment Part                                  | `PaymentPart`                              | | Payment Part Item                             | `PaymentPartItem`                          | | Payment Run                                   | `PaymentRun`                               | | Payment Transaction Log                       | `PaymentTransactionLog`                    | | Processed Usage                               | `ProcessedUsage`                           | | Product                                       | `Product`                                  | | Product Rate Plan                             | `ProductRatePlan`                          | | Product Rate Plan Charge                      | `ProductRatePlanCharge`                    | | Product Rate Plan Charge Tier                 | `ProductRatePlanChargeTier`                | | Rate Plan                                     | `RatePlan`                                 | | Rate Plan Charge                              | `RatePlanCharge`                           | | Rate Plan Charge Tier                         | `RatePlanChargeTier`                       | | Refund                                        | `Refund`                                   | | Refund Application                            | `RefundApplication`                        | | Refund Application Item                       | `RefundApplicationItem`                    | | Refund Invoice Payment                        | `RefundInvoicePayment`                     | | Refund Part                                   | `RefundPart`                               | | Refund Part Item                              | `RefundPartItem`                           | | Refund Transaction Log                        | `RefundTransactionLog`                     | | Revenue Charge Summary                        | `RevenueChargeSummary`                     | | Revenue Charge Summary Item                   | `RevenueChargeSummaryItem`                 | | Revenue Event                                 | `RevenueEvent`                             | | Revenue Event Credit Memo Item                | `RevenueEventCreditMemoItem`               | | Revenue Event Debit Memo Item                 | `RevenueEventDebitMemoItem`                | | Revenue Event Invoice Item                    | `RevenueEventInvoiceItem`                  | | Revenue Event Invoice Item Adjustment         | `RevenueEventInvoiceItemAdjustment`        | | Revenue Event Item                            | `RevenueEventItem`                         | | Revenue Event Item Credit Memo Item           | `RevenueEventItemCreditMemoItem`           | | Revenue Event Item Debit Memo Item            | `RevenueEventItemDebitMemoItem`            | | Revenue Event Item Invoice Item               | `RevenueEventItemInvoiceItem`              | | Revenue Event Item Invoice Item Adjustment    | `RevenueEventItemInvoiceItemAdjustment`    | | Revenue Event Type                            | `RevenueEventType`                         | | Revenue Schedule                              | `RevenueSchedule`                          | | Revenue Schedule Credit Memo Item             | `RevenueScheduleCreditMemoItem`            | | Revenue Schedule Debit Memo Item              | `RevenueScheduleDebitMemoItem`             | | Revenue Schedule Invoice Item                 | `RevenueScheduleInvoiceItem`               | | Revenue Schedule Invoice Item Adjustment      | `RevenueScheduleInvoiceItemAdjustment`     | | Revenue Schedule Item                         | `RevenueScheduleItem`                      | | Revenue Schedule Item Credit Memo Item        | `RevenueScheduleItemCreditMemoItem`        | | Revenue Schedule Item Debit Memo Item         | `RevenueScheduleItemDebitMemoItem`         | | Revenue Schedule Item Invoice Item            | `RevenueScheduleItemInvoiceItem`           | | Revenue Schedule Item Invoice Item Adjustment | `RevenueScheduleItemInvoiceItemAdjustment` | | Subscription                                  | `Subscription`                             | | Taxable Item Snapshot                         | `TaxableItemSnapshot`                      | | Taxation Item                                 | `TaxationItem`                             | | Updater Batch                                 | `UpdaterBatch`                             | | Usage                                         | `Usage`                                    | 

OpenAPI spec version: 2018-02-27
Contact: docs@zuora.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.0-SNAPSHOT

=end

require 'date'

module Zuora
  class ProxyGetPaymentMethodSnapshot
    # The ID of the customer account associated with this payment method.
    attr_accessor :account_id

    # The nine-digit routing number or ABA number used by banks. Applicable to ACH payment methods.
    attr_accessor :ach_aba_code

    # The name of the account holder, which can be either a person or a company. Applicable to ACH payment methods.
    attr_accessor :ach_account_name

    # This is a masked displayable version of the ACH account number, used for security purposes. For example: `XXXXXXXXX54321`.
    attr_accessor :ach_account_number_mask

    # The type of bank account associated with the ACH payment.
    attr_accessor :ach_account_type

    # The name of the bank where the ACH payment account is held.
    attr_accessor :ach_bank_name

    # The branch code of the bank used for direct debit.
    attr_accessor :bank_branch_code

    # The check digit in the international bank account number, which confirms the validity of the account. Applicable to direct debit payment methods.
    attr_accessor :bank_check_digit

    # The city of the direct debit bank.
    attr_accessor :bank_city

    # The sort code or number that identifies the bank. This is also known as the sort code.
    attr_accessor :bank_code

    # The first six digits of the payment method's number, such as the credit card number or account number. Banks use this number to identify a payment method.
    attr_accessor :bank_identification_number

    # The name of the direct debit bank.
    attr_accessor :bank_name

    # The zip code or postal code of the direct debit bank.
    attr_accessor :bank_postal_code

    # The name of the street of the direct debit bank.
    attr_accessor :bank_street_name

    # The number of the direct debit bank.
    attr_accessor :bank_street_number

    # The name on the direct debit bank account.
    attr_accessor :bank_transfer_account_name

    # This is a masked displayable version of the bank account number, used for security purposes. For example: `XXXXXXXXX54321`.
    attr_accessor :bank_transfer_account_number_mask

    # The type of the customer's bank account. Applicable to direct debit payment methods.
    attr_accessor :bank_transfer_account_type

    # Specifies the type of direct debit transfer. The value of this field is dependent on the country of the user.  Possible Values:    * `AutomatischIncasso` (NL)  * `LastschriftDE` (Germany)  * `LastschriftAT` (Austria)  * `DemandeDePrelevement` (FR)  * `DirectDebitUK` (UK)  * `Domicil` (Belgium)  * `LastschriftCH` (CH)  * `RID` (Italy)  * `OrdenDeDomiciliacion` (Spain) 
    attr_accessor :bank_transfer_type

    # The business identification code for Swiss direct payment methods that use the Global Collect payment gateway. Only applicable to direct debit payments in Switzerland with Global Collect.
    attr_accessor :business_identification_code

    # The city of the customer's address. Applicable to debit payment methods.
    attr_accessor :city

    # The two-letter country code of the customer's address. Applicable to direct debit payment methods.
    attr_accessor :country

    # The first line of the card holder's address, which is often a street address or business name. Applicable to credit card and direct debit payment methods.
    attr_accessor :credit_card_address1

    # The second line of the card holder's address. Applicable to credit card and direct debit payment methods.
    attr_accessor :credit_card_address2

    # The city of the card holder's address. Applicable to credit card and direct debit payment methods.
    attr_accessor :credit_card_city

    # The country of the card holder's address.
    attr_accessor :credit_card_country

    # The expiration month of the credit card or debit card. Applicable to credit card and direct debit payment methods.
    attr_accessor :credit_card_expiration_month

    # The expiration month of the credit card or debit card. Applicable to credit card and direct debit payment methods.
    attr_accessor :credit_card_expiration_year

    # The full name of the card holder. Applicable to credit card and direct debit payment methods.
    attr_accessor :credit_card_holder_name

    # A masked version of the credit or debit card number.
    attr_accessor :credit_card_mask_number

    # The billing address's zip code.
    attr_accessor :credit_card_postal_code

    # The billing address's state. Applicable if `CreditCardCountry` is either Canada or the US.
    attr_accessor :credit_card_state

    # The type of credit card or debit card.
    attr_accessor :credit_card_type

    # The session ID of the user when the `PaymentMethod` was created or updated.
    attr_accessor :device_session_id

    # An email address for the payment method in addition to the bill to contact email address.
    attr_accessor :email

    # Indicates if the customer has an existing mandate or a new mandate. Only applicable to direct debit payment methods.
    attr_accessor :existing_mandate

    # The customer's first name. Only applicable to direct debit payment methods.
    attr_accessor :first_name

    # The International Bank Account Number. Only applicable to direct debit payment methods.
    attr_accessor :iban

    # The IP address of the user when the payment method was created or updated.
    attr_accessor :ip_address

    # Object identifier.
    attr_accessor :id

    # The date of the last failed attempt to collect payment with this payment method.
    attr_accessor :last_failed_sale_transaction_date

    # The customer's last name. Only applicable to direct debit payment methods.
    attr_accessor :last_name

    # The date of the most recent transaction.
    attr_accessor :last_transaction_date_time

    # The status of the most recent transaction.
    attr_accessor :last_transaction_status

    # The date when the mandate was created, in `yyyy-mm-dd` format. A mandate is a signed authorization for UK and NL customers. Only applicable to direct debit payment methods.
    attr_accessor :mandate_creation_date

    # The ID of the mandate. A mandate is a signed authorization for UK and NL customers. Only applicable to direct debit payment methods.
    attr_accessor :mandate_id

    # Indicates if  the mandate was received. A mandate is a signed authorization for UK and NL customers. Only applicable to direct debit payment methods.
    attr_accessor :mandate_received

    # The date when the mandate was last updated, in `yyyy-mm-dd` format. A mandate is a signed authorization for UK and NL customers. Only applicable to direct debit payment methods.
    attr_accessor :mandate_update_date

    # The number of allowable consecutive failures Zuora attempts with the payment method before stopping.
    attr_accessor :max_consecutive_payment_failures

    # The name of the payment method.
    attr_accessor :name

    # The number of consecutive failed payment for the payment method.
    attr_accessor :num_consecutive_failures

    # Object identifier of the payment method.
    attr_accessor :payment_method_id

    # Specifies the status of the payment method.
    attr_accessor :payment_method_status

    # The retry interval setting, which prevents making a payment attempt if the last failed attempt was within the last specified number of hours.
    attr_accessor :payment_retry_window

    # The PayPal billing agreement ID, which is a contract between two PayPal accounts.
    attr_accessor :paypal_baid

    # The email address associated with the account holder's PayPal account or of the PayPal account of the person paying for the service.
    attr_accessor :paypal_email

    # PayPal's Adaptive Payments API key.
    attr_accessor :paypal_preapproval_key

    # Specifies the PayPal gateway: PayFlow Pro (Express Checkout) or Adaptive Payments.
    attr_accessor :paypal_type

    # The phone number that the account holder registered with the bank. This field is used for credit card validation when passing to a gateway.
    attr_accessor :phone

    # The zip code of the customer's address. Only applicable to direct debit payment methods.
    attr_accessor :postal_code

    # A gateway unique identifier that replaces sensitive payment method data. Applicable to CC Reference Transaction payment methods.
    attr_accessor :second_token_id

    # The state of the customer's address. Only applicable to direct debit payment methods.
    attr_accessor :state

    # The street name of the customer's address. Only applicable to direct debit payment methods.
    attr_accessor :street_name

    # The street number of the customer's address. Only applicable to direct debit payment methods.
    attr_accessor :street_number

    # A gateway unique identifier that replaces sensitive payment method data or represents a gateway's unique customer profile. Applicable to CC Reference Transaction payment methods.
    attr_accessor :token_id

    # The number of error payments that used this payment method.
    attr_accessor :total_number_of_error_payments

    # The number of successful payments that used this payment method.
    attr_accessor :total_number_of_processed_payments

    # The type of payment method.
    attr_accessor :type

    # Determines whether to use the default retry rules configured in the Zuora Payments settings.
    attr_accessor :use_default_retry_rule

    class EnumAttributeValidator
      attr_reader :datatype
      attr_reader :allowable_values

      def initialize(datatype, allowable_values)
        @allowable_values = allowable_values.map do |value|
          case datatype.to_s
          when /Integer/i
            value.to_i
          when /Float/i
            value.to_f
          else
            value
          end
        end
      end

      def valid?(value)
        !value || allowable_values.include?(value)
      end
    end

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'account_id' => :'AccountId',
        :'ach_aba_code' => :'AchAbaCode',
        :'ach_account_name' => :'AchAccountName',
        :'ach_account_number_mask' => :'AchAccountNumberMask',
        :'ach_account_type' => :'AchAccountType',
        :'ach_bank_name' => :'AchBankName',
        :'bank_branch_code' => :'BankBranchCode',
        :'bank_check_digit' => :'BankCheckDigit',
        :'bank_city' => :'BankCity',
        :'bank_code' => :'BankCode',
        :'bank_identification_number' => :'BankIdentificationNumber',
        :'bank_name' => :'BankName',
        :'bank_postal_code' => :'BankPostalCode',
        :'bank_street_name' => :'BankStreetName',
        :'bank_street_number' => :'BankStreetNumber',
        :'bank_transfer_account_name' => :'BankTransferAccountName',
        :'bank_transfer_account_number_mask' => :'BankTransferAccountNumberMask',
        :'bank_transfer_account_type' => :'BankTransferAccountType',
        :'bank_transfer_type' => :'BankTransferType',
        :'business_identification_code' => :'BusinessIdentificationCode',
        :'city' => :'City',
        :'country' => :'Country',
        :'credit_card_address1' => :'CreditCardAddress1',
        :'credit_card_address2' => :'CreditCardAddress2',
        :'credit_card_city' => :'CreditCardCity',
        :'credit_card_country' => :'CreditCardCountry',
        :'credit_card_expiration_month' => :'CreditCardExpirationMonth',
        :'credit_card_expiration_year' => :'CreditCardExpirationYear',
        :'credit_card_holder_name' => :'CreditCardHolderName',
        :'credit_card_mask_number' => :'CreditCardMaskNumber',
        :'credit_card_postal_code' => :'CreditCardPostalCode',
        :'credit_card_state' => :'CreditCardState',
        :'credit_card_type' => :'CreditCardType',
        :'device_session_id' => :'DeviceSessionId',
        :'email' => :'Email',
        :'existing_mandate' => :'ExistingMandate',
        :'first_name' => :'FirstName',
        :'iban' => :'IBAN',
        :'ip_address' => :'IPAddress',
        :'id' => :'Id',
        :'last_failed_sale_transaction_date' => :'LastFailedSaleTransactionDate',
        :'last_name' => :'LastName',
        :'last_transaction_date_time' => :'LastTransactionDateTime',
        :'last_transaction_status' => :'LastTransactionStatus',
        :'mandate_creation_date' => :'MandateCreationDate',
        :'mandate_id' => :'MandateID',
        :'mandate_received' => :'MandateReceived',
        :'mandate_update_date' => :'MandateUpdateDate',
        :'max_consecutive_payment_failures' => :'MaxConsecutivePaymentFailures',
        :'name' => :'Name',
        :'num_consecutive_failures' => :'NumConsecutiveFailures',
        :'payment_method_id' => :'PaymentMethodId',
        :'payment_method_status' => :'PaymentMethodStatus',
        :'payment_retry_window' => :'PaymentRetryWindow',
        :'paypal_baid' => :'PaypalBaid',
        :'paypal_email' => :'PaypalEmail',
        :'paypal_preapproval_key' => :'PaypalPreapprovalKey',
        :'paypal_type' => :'PaypalType',
        :'phone' => :'Phone',
        :'postal_code' => :'PostalCode',
        :'second_token_id' => :'SecondTokenId',
        :'state' => :'State',
        :'street_name' => :'StreetName',
        :'street_number' => :'StreetNumber',
        :'token_id' => :'TokenId',
        :'total_number_of_error_payments' => :'TotalNumberOfErrorPayments',
        :'total_number_of_processed_payments' => :'TotalNumberOfProcessedPayments',
        :'type' => :'Type',
        :'use_default_retry_rule' => :'UseDefaultRetryRule'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'account_id' => :'String',
        :'ach_aba_code' => :'String',
        :'ach_account_name' => :'String',
        :'ach_account_number_mask' => :'String',
        :'ach_account_type' => :'String',
        :'ach_bank_name' => :'String',
        :'bank_branch_code' => :'String',
        :'bank_check_digit' => :'String',
        :'bank_city' => :'String',
        :'bank_code' => :'String',
        :'bank_identification_number' => :'String',
        :'bank_name' => :'String',
        :'bank_postal_code' => :'String',
        :'bank_street_name' => :'String',
        :'bank_street_number' => :'String',
        :'bank_transfer_account_name' => :'String',
        :'bank_transfer_account_number_mask' => :'String',
        :'bank_transfer_account_type' => :'String',
        :'bank_transfer_type' => :'String',
        :'business_identification_code' => :'String',
        :'city' => :'String',
        :'country' => :'String',
        :'credit_card_address1' => :'String',
        :'credit_card_address2' => :'String',
        :'credit_card_city' => :'String',
        :'credit_card_country' => :'String',
        :'credit_card_expiration_month' => :'Integer',
        :'credit_card_expiration_year' => :'Integer',
        :'credit_card_holder_name' => :'String',
        :'credit_card_mask_number' => :'String',
        :'credit_card_postal_code' => :'String',
        :'credit_card_state' => :'String',
        :'credit_card_type' => :'String',
        :'device_session_id' => :'String',
        :'email' => :'String',
        :'existing_mandate' => :'String',
        :'first_name' => :'String',
        :'iban' => :'String',
        :'ip_address' => :'String',
        :'id' => :'String',
        :'last_failed_sale_transaction_date' => :'DateTime',
        :'last_name' => :'String',
        :'last_transaction_date_time' => :'DateTime',
        :'last_transaction_status' => :'String',
        :'mandate_creation_date' => :'Date',
        :'mandate_id' => :'String',
        :'mandate_received' => :'String',
        :'mandate_update_date' => :'Date',
        :'max_consecutive_payment_failures' => :'Integer',
        :'name' => :'String',
        :'num_consecutive_failures' => :'Integer',
        :'payment_method_id' => :'String',
        :'payment_method_status' => :'String',
        :'payment_retry_window' => :'Integer',
        :'paypal_baid' => :'String',
        :'paypal_email' => :'String',
        :'paypal_preapproval_key' => :'String',
        :'paypal_type' => :'String',
        :'phone' => :'String',
        :'postal_code' => :'String',
        :'second_token_id' => :'String',
        :'state' => :'String',
        :'street_name' => :'String',
        :'street_number' => :'String',
        :'token_id' => :'String',
        :'total_number_of_error_payments' => :'Integer',
        :'total_number_of_processed_payments' => :'Integer',
        :'type' => :'String',
        :'use_default_retry_rule' => :'BOOLEAN'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'AccountId')
        self.account_id = attributes[:'AccountId']
      end

      if attributes.has_key?(:'AchAbaCode')
        self.ach_aba_code = attributes[:'AchAbaCode']
      end

      if attributes.has_key?(:'AchAccountName')
        self.ach_account_name = attributes[:'AchAccountName']
      end

      if attributes.has_key?(:'AchAccountNumberMask')
        self.ach_account_number_mask = attributes[:'AchAccountNumberMask']
      end

      if attributes.has_key?(:'AchAccountType')
        self.ach_account_type = attributes[:'AchAccountType']
      end

      if attributes.has_key?(:'AchBankName')
        self.ach_bank_name = attributes[:'AchBankName']
      end

      if attributes.has_key?(:'BankBranchCode')
        self.bank_branch_code = attributes[:'BankBranchCode']
      end

      if attributes.has_key?(:'BankCheckDigit')
        self.bank_check_digit = attributes[:'BankCheckDigit']
      end

      if attributes.has_key?(:'BankCity')
        self.bank_city = attributes[:'BankCity']
      end

      if attributes.has_key?(:'BankCode')
        self.bank_code = attributes[:'BankCode']
      end

      if attributes.has_key?(:'BankIdentificationNumber')
        self.bank_identification_number = attributes[:'BankIdentificationNumber']
      end

      if attributes.has_key?(:'BankName')
        self.bank_name = attributes[:'BankName']
      end

      if attributes.has_key?(:'BankPostalCode')
        self.bank_postal_code = attributes[:'BankPostalCode']
      end

      if attributes.has_key?(:'BankStreetName')
        self.bank_street_name = attributes[:'BankStreetName']
      end

      if attributes.has_key?(:'BankStreetNumber')
        self.bank_street_number = attributes[:'BankStreetNumber']
      end

      if attributes.has_key?(:'BankTransferAccountName')
        self.bank_transfer_account_name = attributes[:'BankTransferAccountName']
      end

      if attributes.has_key?(:'BankTransferAccountNumberMask')
        self.bank_transfer_account_number_mask = attributes[:'BankTransferAccountNumberMask']
      end

      if attributes.has_key?(:'BankTransferAccountType')
        self.bank_transfer_account_type = attributes[:'BankTransferAccountType']
      end

      if attributes.has_key?(:'BankTransferType')
        self.bank_transfer_type = attributes[:'BankTransferType']
      end

      if attributes.has_key?(:'BusinessIdentificationCode')
        self.business_identification_code = attributes[:'BusinessIdentificationCode']
      end

      if attributes.has_key?(:'City')
        self.city = attributes[:'City']
      end

      if attributes.has_key?(:'Country')
        self.country = attributes[:'Country']
      end

      if attributes.has_key?(:'CreditCardAddress1')
        self.credit_card_address1 = attributes[:'CreditCardAddress1']
      end

      if attributes.has_key?(:'CreditCardAddress2')
        self.credit_card_address2 = attributes[:'CreditCardAddress2']
      end

      if attributes.has_key?(:'CreditCardCity')
        self.credit_card_city = attributes[:'CreditCardCity']
      end

      if attributes.has_key?(:'CreditCardCountry')
        self.credit_card_country = attributes[:'CreditCardCountry']
      end

      if attributes.has_key?(:'CreditCardExpirationMonth')
        self.credit_card_expiration_month = attributes[:'CreditCardExpirationMonth']
      end

      if attributes.has_key?(:'CreditCardExpirationYear')
        self.credit_card_expiration_year = attributes[:'CreditCardExpirationYear']
      end

      if attributes.has_key?(:'CreditCardHolderName')
        self.credit_card_holder_name = attributes[:'CreditCardHolderName']
      end

      if attributes.has_key?(:'CreditCardMaskNumber')
        self.credit_card_mask_number = attributes[:'CreditCardMaskNumber']
      end

      if attributes.has_key?(:'CreditCardPostalCode')
        self.credit_card_postal_code = attributes[:'CreditCardPostalCode']
      end

      if attributes.has_key?(:'CreditCardState')
        self.credit_card_state = attributes[:'CreditCardState']
      end

      if attributes.has_key?(:'CreditCardType')
        self.credit_card_type = attributes[:'CreditCardType']
      end

      if attributes.has_key?(:'DeviceSessionId')
        self.device_session_id = attributes[:'DeviceSessionId']
      end

      if attributes.has_key?(:'Email')
        self.email = attributes[:'Email']
      end

      if attributes.has_key?(:'ExistingMandate')
        self.existing_mandate = attributes[:'ExistingMandate']
      end

      if attributes.has_key?(:'FirstName')
        self.first_name = attributes[:'FirstName']
      end

      if attributes.has_key?(:'IBAN')
        self.iban = attributes[:'IBAN']
      end

      if attributes.has_key?(:'IPAddress')
        self.ip_address = attributes[:'IPAddress']
      end

      if attributes.has_key?(:'Id')
        self.id = attributes[:'Id']
      end

      if attributes.has_key?(:'LastFailedSaleTransactionDate')
        self.last_failed_sale_transaction_date = attributes[:'LastFailedSaleTransactionDate']
      end

      if attributes.has_key?(:'LastName')
        self.last_name = attributes[:'LastName']
      end

      if attributes.has_key?(:'LastTransactionDateTime')
        self.last_transaction_date_time = attributes[:'LastTransactionDateTime']
      end

      if attributes.has_key?(:'LastTransactionStatus')
        self.last_transaction_status = attributes[:'LastTransactionStatus']
      end

      if attributes.has_key?(:'MandateCreationDate')
        self.mandate_creation_date = attributes[:'MandateCreationDate']
      end

      if attributes.has_key?(:'MandateID')
        self.mandate_id = attributes[:'MandateID']
      end

      if attributes.has_key?(:'MandateReceived')
        self.mandate_received = attributes[:'MandateReceived']
      end

      if attributes.has_key?(:'MandateUpdateDate')
        self.mandate_update_date = attributes[:'MandateUpdateDate']
      end

      if attributes.has_key?(:'MaxConsecutivePaymentFailures')
        self.max_consecutive_payment_failures = attributes[:'MaxConsecutivePaymentFailures']
      end

      if attributes.has_key?(:'Name')
        self.name = attributes[:'Name']
      end

      if attributes.has_key?(:'NumConsecutiveFailures')
        self.num_consecutive_failures = attributes[:'NumConsecutiveFailures']
      end

      if attributes.has_key?(:'PaymentMethodId')
        self.payment_method_id = attributes[:'PaymentMethodId']
      end

      if attributes.has_key?(:'PaymentMethodStatus')
        self.payment_method_status = attributes[:'PaymentMethodStatus']
      end

      if attributes.has_key?(:'PaymentRetryWindow')
        self.payment_retry_window = attributes[:'PaymentRetryWindow']
      end

      if attributes.has_key?(:'PaypalBaid')
        self.paypal_baid = attributes[:'PaypalBaid']
      end

      if attributes.has_key?(:'PaypalEmail')
        self.paypal_email = attributes[:'PaypalEmail']
      end

      if attributes.has_key?(:'PaypalPreapprovalKey')
        self.paypal_preapproval_key = attributes[:'PaypalPreapprovalKey']
      end

      if attributes.has_key?(:'PaypalType')
        self.paypal_type = attributes[:'PaypalType']
      end

      if attributes.has_key?(:'Phone')
        self.phone = attributes[:'Phone']
      end

      if attributes.has_key?(:'PostalCode')
        self.postal_code = attributes[:'PostalCode']
      end

      if attributes.has_key?(:'SecondTokenId')
        self.second_token_id = attributes[:'SecondTokenId']
      end

      if attributes.has_key?(:'State')
        self.state = attributes[:'State']
      end

      if attributes.has_key?(:'StreetName')
        self.street_name = attributes[:'StreetName']
      end

      if attributes.has_key?(:'StreetNumber')
        self.street_number = attributes[:'StreetNumber']
      end

      if attributes.has_key?(:'TokenId')
        self.token_id = attributes[:'TokenId']
      end

      if attributes.has_key?(:'TotalNumberOfErrorPayments')
        self.total_number_of_error_payments = attributes[:'TotalNumberOfErrorPayments']
      end

      if attributes.has_key?(:'TotalNumberOfProcessedPayments')
        self.total_number_of_processed_payments = attributes[:'TotalNumberOfProcessedPayments']
      end

      if attributes.has_key?(:'Type')
        self.type = attributes[:'Type']
      end

      if attributes.has_key?(:'UseDefaultRetryRule')
        self.use_default_retry_rule = attributes[:'UseDefaultRetryRule']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      ach_account_type_validator = EnumAttributeValidator.new('String', ['BusinessChecking', 'Checking', 'Saving'])
      return false unless ach_account_type_validator.valid?(@ach_account_type)
      bank_transfer_type_validator = EnumAttributeValidator.new('String', ['AutomatischIncasso', 'LastschriftDE', 'LastschriftAT', 'DemandeDePrelevement', 'DirectDebitUK', 'Domicil', 'LastschriftCH', 'RID', 'OrdenDeDomiciliacion'])
      return false unless bank_transfer_type_validator.valid?(@bank_transfer_type)
      credit_card_type_validator = EnumAttributeValidator.new('String', ['AmericanExpress', 'Discover', 'MasterCard', 'Visa'])
      return false unless credit_card_type_validator.valid?(@credit_card_type)
      existing_mandate_validator = EnumAttributeValidator.new('String', ['Yes', 'No'])
      return false unless existing_mandate_validator.valid?(@existing_mandate)
      payment_method_status_validator = EnumAttributeValidator.new('String', ['Active', 'Closed'])
      return false unless payment_method_status_validator.valid?(@payment_method_status)
      paypal_type_validator = EnumAttributeValidator.new('String', ['ExpressCheckout', 'AdaptivePayments'])
      return false unless paypal_type_validator.valid?(@paypal_type)
      type_validator = EnumAttributeValidator.new('String', ['ACH', 'ApplePay', 'BankTransfer', 'Cash', 'Check', 'CreditCard', 'CreditCardReferenceTransaction', 'DebitCard', 'Other', 'PayPal', 'WireTransfer'])
      return false unless type_validator.valid?(@type)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] ach_account_type Object to be assigned
    def ach_account_type=(ach_account_type)
      validator = EnumAttributeValidator.new('String', ['BusinessChecking', 'Checking', 'Saving'])
      unless validator.valid?(ach_account_type)
        fail ArgumentError, 'invalid value for "ach_account_type", must be one of #{validator.allowable_values}.'
      end
      @ach_account_type = ach_account_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] bank_transfer_type Object to be assigned
    def bank_transfer_type=(bank_transfer_type)
      validator = EnumAttributeValidator.new('String', ['AutomatischIncasso', 'LastschriftDE', 'LastschriftAT', 'DemandeDePrelevement', 'DirectDebitUK', 'Domicil', 'LastschriftCH', 'RID', 'OrdenDeDomiciliacion'])
      unless validator.valid?(bank_transfer_type)
        fail ArgumentError, 'invalid value for "bank_transfer_type", must be one of #{validator.allowable_values}.'
      end
      @bank_transfer_type = bank_transfer_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] credit_card_type Object to be assigned
    def credit_card_type=(credit_card_type)
      validator = EnumAttributeValidator.new('String', ['AmericanExpress', 'Discover', 'MasterCard', 'Visa'])
      unless validator.valid?(credit_card_type)
        fail ArgumentError, 'invalid value for "credit_card_type", must be one of #{validator.allowable_values}.'
      end
      @credit_card_type = credit_card_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] existing_mandate Object to be assigned
    def existing_mandate=(existing_mandate)
      validator = EnumAttributeValidator.new('String', ['Yes', 'No'])
      unless validator.valid?(existing_mandate)
        fail ArgumentError, 'invalid value for "existing_mandate", must be one of #{validator.allowable_values}.'
      end
      @existing_mandate = existing_mandate
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] payment_method_status Object to be assigned
    def payment_method_status=(payment_method_status)
      validator = EnumAttributeValidator.new('String', ['Active', 'Closed'])
      unless validator.valid?(payment_method_status)
        fail ArgumentError, 'invalid value for "payment_method_status", must be one of #{validator.allowable_values}.'
      end
      @payment_method_status = payment_method_status
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] paypal_type Object to be assigned
    def paypal_type=(paypal_type)
      validator = EnumAttributeValidator.new('String', ['ExpressCheckout', 'AdaptivePayments'])
      unless validator.valid?(paypal_type)
        fail ArgumentError, 'invalid value for "paypal_type", must be one of #{validator.allowable_values}.'
      end
      @paypal_type = paypal_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] type Object to be assigned
    def type=(type)
      validator = EnumAttributeValidator.new('String', ['ACH', 'ApplePay', 'BankTransfer', 'Cash', 'Check', 'CreditCard', 'CreditCardReferenceTransaction', 'DebitCard', 'Other', 'PayPal', 'WireTransfer'])
      unless validator.valid?(type)
        fail ArgumentError, 'invalid value for "type", must be one of #{validator.allowable_values}.'
      end
      @type = type
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          account_id == o.account_id &&
          ach_aba_code == o.ach_aba_code &&
          ach_account_name == o.ach_account_name &&
          ach_account_number_mask == o.ach_account_number_mask &&
          ach_account_type == o.ach_account_type &&
          ach_bank_name == o.ach_bank_name &&
          bank_branch_code == o.bank_branch_code &&
          bank_check_digit == o.bank_check_digit &&
          bank_city == o.bank_city &&
          bank_code == o.bank_code &&
          bank_identification_number == o.bank_identification_number &&
          bank_name == o.bank_name &&
          bank_postal_code == o.bank_postal_code &&
          bank_street_name == o.bank_street_name &&
          bank_street_number == o.bank_street_number &&
          bank_transfer_account_name == o.bank_transfer_account_name &&
          bank_transfer_account_number_mask == o.bank_transfer_account_number_mask &&
          bank_transfer_account_type == o.bank_transfer_account_type &&
          bank_transfer_type == o.bank_transfer_type &&
          business_identification_code == o.business_identification_code &&
          city == o.city &&
          country == o.country &&
          credit_card_address1 == o.credit_card_address1 &&
          credit_card_address2 == o.credit_card_address2 &&
          credit_card_city == o.credit_card_city &&
          credit_card_country == o.credit_card_country &&
          credit_card_expiration_month == o.credit_card_expiration_month &&
          credit_card_expiration_year == o.credit_card_expiration_year &&
          credit_card_holder_name == o.credit_card_holder_name &&
          credit_card_mask_number == o.credit_card_mask_number &&
          credit_card_postal_code == o.credit_card_postal_code &&
          credit_card_state == o.credit_card_state &&
          credit_card_type == o.credit_card_type &&
          device_session_id == o.device_session_id &&
          email == o.email &&
          existing_mandate == o.existing_mandate &&
          first_name == o.first_name &&
          iban == o.iban &&
          ip_address == o.ip_address &&
          id == o.id &&
          last_failed_sale_transaction_date == o.last_failed_sale_transaction_date &&
          last_name == o.last_name &&
          last_transaction_date_time == o.last_transaction_date_time &&
          last_transaction_status == o.last_transaction_status &&
          mandate_creation_date == o.mandate_creation_date &&
          mandate_id == o.mandate_id &&
          mandate_received == o.mandate_received &&
          mandate_update_date == o.mandate_update_date &&
          max_consecutive_payment_failures == o.max_consecutive_payment_failures &&
          name == o.name &&
          num_consecutive_failures == o.num_consecutive_failures &&
          payment_method_id == o.payment_method_id &&
          payment_method_status == o.payment_method_status &&
          payment_retry_window == o.payment_retry_window &&
          paypal_baid == o.paypal_baid &&
          paypal_email == o.paypal_email &&
          paypal_preapproval_key == o.paypal_preapproval_key &&
          paypal_type == o.paypal_type &&
          phone == o.phone &&
          postal_code == o.postal_code &&
          second_token_id == o.second_token_id &&
          state == o.state &&
          street_name == o.street_name &&
          street_number == o.street_number &&
          token_id == o.token_id &&
          total_number_of_error_payments == o.total_number_of_error_payments &&
          total_number_of_processed_payments == o.total_number_of_processed_payments &&
          type == o.type &&
          use_default_retry_rule == o.use_default_retry_rule
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [account_id, ach_aba_code, ach_account_name, ach_account_number_mask, ach_account_type, ach_bank_name, bank_branch_code, bank_check_digit, bank_city, bank_code, bank_identification_number, bank_name, bank_postal_code, bank_street_name, bank_street_number, bank_transfer_account_name, bank_transfer_account_number_mask, bank_transfer_account_type, bank_transfer_type, business_identification_code, city, country, credit_card_address1, credit_card_address2, credit_card_city, credit_card_country, credit_card_expiration_month, credit_card_expiration_year, credit_card_holder_name, credit_card_mask_number, credit_card_postal_code, credit_card_state, credit_card_type, device_session_id, email, existing_mandate, first_name, iban, ip_address, id, last_failed_sale_transaction_date, last_name, last_transaction_date_time, last_transaction_status, mandate_creation_date, mandate_id, mandate_received, mandate_update_date, max_consecutive_payment_failures, name, num_consecutive_failures, payment_method_id, payment_method_status, payment_retry_window, paypal_baid, paypal_email, paypal_preapproval_key, paypal_type, phone, postal_code, second_token_id, state, street_name, street_number, token_id, total_number_of_error_payments, total_number_of_processed_payments, type, use_default_retry_rule].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :BOOLEAN
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        temp_model = Zuora.const_get(type).new
        temp_model.build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        next if value.nil?
        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end
  end
end
