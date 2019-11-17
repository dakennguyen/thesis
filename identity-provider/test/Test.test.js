const Test = artifacts.require("Test");

contract('Test', (accounts) => {
    let meme;

    before(async () => {
        meme = await Test.deployed();
    });

    describe('deployment', async () => {
        it('deploys successfully', async () => {
            const address = meme.address;
            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
        });
    });

    describe('storage', async () => {
        it('updates the memeHash', async () => {
            let memeHash = 'abc123';
            await meme.set(memeHash);
            const result = await meme.get();
            assert.equal(result, memeHash);
        });
    });
});
