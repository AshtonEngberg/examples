const identityUtils = require("./utils/identity");
const { 
  anonymousActor,
  anonymousPrincipal,
  getRandomPrincipal
} = identityUtils;

jest.setTimeout(60000);   

const testInvoice = {
  amount: 1000000n,
  token: {
    symbol: "ICP",
  },
  details: [],
  permissions: [],
};

describe("test that the anonymous principal is disallowed", () => {
  it("should not allow anonymous caller to create an invoice", async () => {
    const result = await anonymousActor.create_invoice(testInvoice);
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to get creators allowed list", async () => {
    const result = await anonymousActor.get_allowed_creators_list();
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to add to creators allowed list", async () => {
    const result = await anonymousActor.add_allowed_creator({ who: getRandomPrincipal() });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to remove from creators allowed list", async () => {
    const result = await anonymousActor.remove_allowed_creator({ who: getRandomPrincipal() });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to set the delegated admin", async () => {
    const result = await anonymousActor.set_delegated_administrator({ who: getRandomPrincipal() });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to get the delegated admin", async () => {
    const result = await anonymousActor.get_delegated_administrator();
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to get their balance", async () => {
    const result = await anonymousActor.get_balance({ token: { symbol: "ICP" } });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to get their consolidation address", async () => {
    const result = await anonymousActor.get_callers_consolidation_address({ token: { symbol: "ICP" } });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller to verify an invoice", async () => {
    const result = await anonymousActor.verify_invoice({ id: 1n })
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
  it("should not allow anonymous caller from transfering", async () => {
    const result = await anonymousActor.transfer({
      amount: 100000n,
      destinationAddress: "d9e7a24235e4d6712c44303a909d2ba3d7c61163fcb5731c8a0741ad48f7dc0d",
      token: {
        symbol: "ICP",
      },
    });
    expect(result.err.kind).toStrictEqual({ NotAuthorized: null });
  });
});