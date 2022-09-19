// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}


contract Test {
    using SafeMath for uint;
    
    address public owner;
    string private _name = "TestToken";
    string private _symbol = "TETO";
    uint256 private _totalSupply  = 100 ;
    uint256 private MAXSUPPLY = 1000 ;
    
 

    event Transfer(address indexed from, address indexed to, uint256 vaue);
    event Approval(address indexed admin, address indexed spender, uint256 value);

    mapping (address => uint256) private _balances;
    mapping (address => mapping(address => uint256))private _allowances;

    constructor(){
        owner = msg.sender;
        _balances[msg.sender] = _totalSupply;
    }

       modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }


    function transfer(address to, uint256 value) public returns (bool){
        require (_balances[msg.sender] >= value ) ;
        require (_allowances[msg.sender][owner] >= value ) ;
        _balances[msg.sender] =_balances[msg.sender].sub(value) ;
        _allowances[msg.sender][owner] =_allowances[msg.sender][owner].sub(value) ;
        _balances[to] =_balances[to].add(value);
        emit Transfer (msg.sender,to,value);
        return true;

    }


     function transferFrom(address payable from,address payable to, uint256 value) public onlyOwner returns (bool){
        require (_balances[from]>= value && _allowances[from][owner] >= value) ;
        require ( from == msg.sender, "The msg.sender should be the address who sends " );
        _allowances[from][owner] =_allowances[from][owner].sub(value);
        _balances[from] =_balances[from].sub(value) ;
        _balances[to] =_balances[to].add(value);
        emit Transfer (msg.sender,to,value);
        return true;
    }

    function approve (address spender, uint256 value) public onlyOwner returns (bool){
        require (spender != msg.sender, "The sender is not the owner");
        require (_balances[spender] >= value , "the value is greater than balance of spender");
        require (_balances[msg.sender] >= value , "the value is greater than balance of msg.sender");
        _allowances [msg.sender][spender] = value;
        emit Approval(msg.sender,spender,value);
        return true;
    }

    function increaseApproval (address spender, uint addedValue) public onlyOwner returns (bool) {
        require (spender != msg.sender, "The sender is not the owner");
        require (_balances[spender] >= _allowances[msg.sender][spender].add(addedValue));
        _allowances[msg.sender][spender] = _allowances[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    function decreaseApproval (address spender, uint subtractedValue) public onlyOwner returns (bool) {
        require (spender != msg.sender, "The sender is not the owner");
        uint oldValue = _allowances[msg.sender][spender];
        if (subtractedValue > oldValue) {
            _allowances[msg.sender][spender] = 0;
        } else {
            _allowances[msg.sender][spender] = oldValue.sub(subtractedValue);
        }
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }
    

    function allowance(address owner, address spender)public view returns (uint256){
        return _allowances[owner][spender];
    }

    function balanceOf(address _owner) public view returns(uint256){
        return _balances[_owner];
    }

    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }

    function name() public view returns(string memory){
        return _name;
    }

     function symbol() public view returns(string memory){
        return _symbol;
    }

       function decimals() public view returns(uint8){
        return 18;
    }

    function mint(address to, uint amount) external onlyOwner{
        require (msg.sender == owner,"only owner");
        require (amount.add(_totalSupply) <= MAXSUPPLY, "You reach the maximum supply");
        _balances [to] =_balances [to].add(amount);
        _totalSupply =_totalSupply.add(amount);
        emit Transfer (address(0),to, amount);
        }

        function burn (uint amount) external  {
        if(amount>0){
        require (_balances[msg.sender] >= amount, "burn amount exceeds balance");
        require (_allowances[msg.sender][owner] >= amount, "The address can burn only the amount that the owner gives");
        _balances [msg.sender] =_balances [msg.sender].sub(amount);
        _allowances [msg.sender][owner] =_allowances [msg.sender][owner].sub(amount);
        _totalSupply =_totalSupply.sub(amount);
        emit Transfer (msg.sender , address(0), amount);
        }

        }
    

} 
