import Result     "mo:base/Result";
import Time       "mo:base/Time";

module {
/**
* Base Types
*/
// #region Base Types
  public type Token = {
    symbol : Text;
  };
  public type TokenVerbose = {
    symbol : Text;
    decimals : Int;
    meta : ?{
      Issuer : Text;
    };
  };
  public type Details = {
    description : Text;
    meta : Blob;
  };
  public type Permissions = {
      canGet : [Principal];
      canVerify : [Principal];
  };
  public type Invoice = {
    id : Nat;
    creator : Principal;
    details : ?Details;
    permissions : ?Permissions;
    amount : Nat;
    amountPaid : Nat;
    token : TokenVerbose;
    verifiedAtTime : ?Time.Time;
    paid : Bool;
    paymentAddress : Text;
  };
// #endregion

/**
* Service Args and Result Types
*/

// #region create_invoice
  public type CreateInvoiceArgs = {
    amount : Nat;
    token : Token;
    permissions: ?Permissions;
    details : ?Details;
  };
  public type CreateInvoiceResult = Result.Result<CreateInvoiceSuccess, CreateInvoiceErr>;
  public type CreateInvoiceSuccess = {
    invoice : Invoice;
  };
  public type CreateInvoiceErr = {
    message : ?Text;
    kind : {
      #BadSize;
      #InvalidToken;
      #InvalidAmount;
      #InvalidDestination;
      #InvalidDetails;
      #MaxInvoicesReached;
      #NotAuthorized;
      #Other;
    };
  };
// #endregion

// #region get_invoice
  public type GetInvoiceArgs = {
    id : Nat;
  };
  public type GetInvoiceResult = Result.Result<GetInvoiceSuccess, GetInvoiceErr>;
  public type GetInvoiceSuccess = {
    invoice : Invoice;
  };
  public type GetInvoiceErr = {
    message : ?Text;
    kind : {
      #InvalidInvoiceId;
      #NotFound;
      #NotAuthorized;
      #Other;
    };
  };
// #endregion

// #region get_balance
  public type GetBalanceArgs = {
    token : Token;
  };
  public type GetBalanceResult = Result.Result<GetBalanceSuccess, GetBalanceErr>;
  public type GetBalanceSuccess = {
    balance : Nat;
  };
  public type GetBalanceErr = {
    message : ?Text;
    kind : {
      #InvalidToken;
      #NotAuthorized;
      #NotFound;
      #Other;
    };
  };
// #endregion

// #region verify_invoice
  public type VerifyInvoiceArgs = {
    id : Nat;
  };
  public type VerifyInvoiceResult = Result.Result<VerifyInvoiceSuccess, VerifyInvoiceErr>;
  public type VerifyInvoiceSuccess = {
    #Paid : {
      invoice : Invoice;
    };
    #AlreadyVerified : {
      invoice : Invoice;
    };
  };
  type VerifyInvoiceErr = {
    message : ?Text;
    kind : {
      #InvalidInvoiceId;
      #NotFound;
      #NotYetPaid;
      #NotAuthorized;
      #Expired;
      #TransferError;
      #InvalidToken;
      #InvalidAccount;
      #Other;
    };
  };
// #endregion

// #region transfer
  public type TransferArgs = {
    amount : Nat;
    token : Token;
    destinationAddress : Text; 
  };
  public type TransferResult = Result.Result<TransferSuccess, TransferError>;
  public type TransferSuccess = {
    blockHeight : Nat64;
  };
  public type TransferError = {
    message : ?Text;
    kind : {
      #BadFee;
      #InsufficientFunds;
      #InsufficientTransferAmount;
      #InvalidToken;
      #InvalidDestination;
      #NotAuthorized;
      #Other;
    };
  };
// #endregion

// #region get_caller_consolidation_address
  public type GetCallersConsolidationAddressArgs = {
    token : Token;
  };
  public type GetCallersConsolidationAddressResult = Result.Result<GetCallersConsolidationAddressSuccess, GetCallersConsolidationAddressErr>;
  public type GetCallersConsolidationAddressSuccess = {
    consolidationAddress : Text
  };
  public type GetCallersConsolidationAddressErr = {
    message : ?Text;
    kind : {
      #InvalidToken;
      #NotAuthorized;
      #Other;
    };
  };
// #endregion

// #region CreatorsAllowedList types 
  public type AddAllowedCreatorArgs = {
    who : Principal
  };
  public type AddAllowedCreatorResult = Result.Result<AddAllowedCreatorSuccess, AddAllowedCreatorErr>;
  public type AddAllowedCreatorSuccess = {
    message : Text;
  };
  public type AddAllowedCreatorErr = {
    message : ?Text;
    kind : {
      #NotAuthorized;
      #AlreadyAdded; 
      #AnonymousIneligible;
      #MaxAllowed;
    }
  };
  public type RemoveAllowedCreatorArgs = {
    who : Principal
  };
  public type RemoveAllowedCreatorResult = Result.Result<RemoveAllowedCreatorSuccess, RemoveAllowedCreatorErr>;
  public type RemoveAllowedCreatorSuccess = {
    message : Text;
  };
  public type RemoveAllowedCreatorErr = {
    message : ?Text;
    kind : {
      #NotAuthorized;
      #NotFound; 
    }
  };
  public type GetAllowedCreatorsListResult = Result.Result<GetAllowedCreatorsListSuccess, GetAllowedCreatorsListErr>;
  public type GetAllowedCreatorsListSuccess = {
    allowed : [Principal];
  };
  public type GetAllowedCreatorsListErr = {
    kind : {
      #NotAuthorized;
    }
  };
// #endregion

// #region set delegated administrator args results
  public type SetDelegatedAdministratorArgs = {
    who : Principal
  };
  public type SetDelegatedAdministratorResult = Result.Result<SetDelegatedAdministratorSuccess, SetDelegatedAdministratorErr>;
  public type SetDelegatedAdministratorSuccess = {
    message : Text;
  };
  public type SetDelegatedAdministratorErr = {
    message : ?Text;
    kind : {
      #NotAuthorized;
      #AnonymousIneligible;
    }
  };
// #endregion
// #region get delegated administrator results
  public type GetDelegatedAdministratorResult = Result.Result<GetDelegatedAdministratorSuccess, GetDelegatedAdministratorErr>;
  public type GetDelegatedAdministratorSuccess = {
    delegatedAdmin : Principal;
  };
  public type GetDelegatedAdministratorErr = {
    kind : {
      #NotAuthorized;
    }
  };
// #endregion


// #region ICP Transfer -> Note not used. 
  public type Memo = Nat64;
  public type SubAccount = Blob;
  public type TimeStamp = {
    timestamp_nanos : Nat64;
  };
  public type ICPTokens = {
    e8s : Nat64;
  };
  public type ICPTransferError = {
    message : ?Text;
    kind : {
      #BadFee : {
        expected_fee : ICPTokens;
      };
      #InsufficientFunds : {
        balance : ICPTokens;
      };
      #TxTooOld : {
        allowed_window_nanos : Nat64;
      };
      #TxCreatedInFuture;
      #TxDuplicate : {
        duplicate_of : Nat;
      };
      #Other;
    }
  };

  public type ICPTransferResult = Result.Result<TransferSuccess, ICPTransferError>;
// #endregion
};
