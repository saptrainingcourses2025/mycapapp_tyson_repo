namespace tyson.common;
using { Currency } from '@sap/cds/common';


type Guid: String(32);

type Gender : String(1) enum{
    male = 'M';
    female = 'F';
    undisclose = 'U';
};

type OrderStatus: String(1) enum{
    New = 'N';
    InProcess = 'I';
    Approved = 'A';
    Rejected = 'X';
    Pending = 'P';
    Delivered = 'D';
}

type AmountT : Decimal(10, 2) @(
    Semantic.amount.currencyCode: 'CURRENCY_Code'
);

aspect Amount{
    CURRENCY: Currency @(title : '{i18n>CURRENCY}');
    GROSS_AMOUNT: AmountT @(title : '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT: AmountT @(title : '{i18n>NET_AMOUNT}');
    TAX_AMOUNT: AmountT @(title : '{i18n>TAX_AMOUNT}');
}

type PhoneNumber : String(30) @assert.format : '^[6-9][0-9]{9}$';
type Email : String(250) @assert.format : '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';


