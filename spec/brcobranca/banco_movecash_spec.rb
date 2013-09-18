#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brcobranca::Boleto::Movecash do
  before(:each) do
  	@campo_dois = "600"
    @valid_attributes = {
      :especie_documento => "RC",
      :moeda => "9",
      :data_documento => Date.today,
      :dias_vencimento => 3,
      :aceite => "N",
      :quantidade => 1,
      :valor => 25.50,
      :cedente => "Movecash",
      :documento_cedente => "53.527.854/0001-97",
      :sacado => "Marcel Movecash 2505",
      :sacado_documento => "12345678900",
      :agencia => "0059",
      :convenio => 5897092,
      :numero_documento => @campo_dois + "095207" # 095207
    }
  end

  it "Criar nova instancia com atributos padrões" do
    boleto_novo = Brcobranca::Boleto::Movecash.new
    boleto_novo.banco.should eql("033")
    boleto_novo.especie_documento.should eql("RC")
    boleto_novo.especie.should eql("R$")
    boleto_novo.moeda.should eql("9")
    boleto_novo.data_documento.should eql(Date.today)
    boleto_novo.dias_vencimento.should eql(3)
    boleto_novo.data_vencimento.should eql(Date.today + 3)
    boleto_novo.aceite.should eql("N")
    boleto_novo.quantidade.should eql(1)
    boleto_novo.valor.should eql(0.0)
    boleto_novo.valor_documento.should eql(0.0)
    boleto_novo.local_pagamento.should eql("QUALQUER BANCO ATÉ O VENCIMENTO")
    boleto_novo.carteira.should eql("101")
  end

  it "Criar nova instancia com atributos válidos" do
    boleto_novo = Brcobranca::Boleto::Movecash.new(@valid_attributes)
    boleto_novo.banco.should eql("033")
    boleto_novo.especie_documento.should eql("RC")
    boleto_novo.especie.should eql("R$")
    boleto_novo.moeda.should eql("9")
    boleto_novo.data_documento.should eql(Date.today)
    boleto_novo.dias_vencimento.should eql(3)
    boleto_novo.data_vencimento.should eql(Date.today + 3)
    boleto_novo.aceite.should eql("N")
    boleto_novo.quantidade.should eql(1)
    boleto_novo.valor.should eql(25.50)
    boleto_novo.valor_documento.should eql(25.50)
    boleto_novo.local_pagamento.should eql("QUALQUER BANCO ATÉ O VENCIMENTO")
    boleto_novo.cedente.should eql("Movecash")
    boleto_novo.documento_cedente.should eql("53.527.854/0001-97")
    boleto_novo.sacado.should eql("Marcel Movecash 2505")
    boleto_novo.sacado_documento.should eql("12345678900")
    boleto_novo.agencia.should eql("0059")
    boleto_novo.convenio.should eql("5897092")
    boleto_novo.numero_documento.should eql("600095207")
    boleto_novo.carteira.should eql("101")
  end

  describe "Gerar boleto Marcel 25/05/2013" do
  	before {
  		@valid_attributes[:data_documento] = Date.parse("2013/05/22")
  		@boleto_novo = Brcobranca::Boleto::Movecash.new(@valid_attributes)
  	}
  	it "codigo_barras must return valid barcode" do
  		@boleto_novo.codigo_barras.should eql("03392570900000025509589709200006000952070101")
  	end

  	it "linha_digitavel must return a valid clean token" do
  		@boleto_novo.codigo_barras.linha_digitavel.should eql("03399.58977 09200.006006 09520.701013 2 57090000002550")
  	end
  end

  describe "Gerar boleto Fernando 21/08/2013" do
  	before {
  		@valid_attributes[:data_documento] = Date.parse("2013/08/21")
  		@valid_attributes[:numero_documento] = @campo_dois + "197042"
  		@valid_attributes[:valor] = 21.63
  		@boleto_novo = Brcobranca::Boleto::Movecash.new(@valid_attributes)
  	}
  	it "codigo_barras must return valid barcode" do
  		@boleto_novo.codigo_barras.should eql("03391580000000021639589709200006001970420101")
  	end

  	it "linha_digitavel must return a valid clean token" do
  		@boleto_novo.codigo_barras.linha_digitavel.should eql("03399.58977 09200.006006 19704.201011 1 58000000002163")
  	end
  end

  it "Busca logotipo do banco" do
    boleto_novo = Brcobranca::Boleto::Movecash.new
    File.exist?(boleto_novo.logotipo).should be_true
    File.stat(boleto_novo.logotipo).zero?.should be_false
  end

  it "should not generate boleto with invalid attributes" do
    boleto_novo = Brcobranca::Boleto::Movecash.new
    lambda { boleto_novo.codigo_barras }.should raise_error(Brcobranca::BoletoInvalido)
    boleto_novo.errors.count.should eql(2)
  end

end
