#include <math.h>
#include <iostream>
#include <TMB.hpp>


// library needed for the multvariate normal distribution
using namespace density;

template<class Type>
vector<Type> Multiply(vector<Type> mat1, matrix<Type> mat2) {

  int i = mat1.size();
  int j = mat2.cols();

  vector<Type> mat3(j);
  for (int c = 0; c < j; c++) {
    mat3(c) = 0.0;
    for (int b = 0; b < i; b++) {
      mat3(c) += mat1(b)*mat2(b,c);
    }
  }
  return(mat3);
}

template<class Type>
matrix<Type> invilrc(matrix<Type> data, matrix<Type> V)
{
  matrix<Type> mult(data.rows(), data.cols()+1);
  matrix<Type> trans(data.rows(),data.cols()+1);
  Type rowtot;

  // back transforming each individual row
  for(int m=0; m<data.rows(); m++){
    rowtot = 0.0;
    for(int l=0; l<(data.cols()+1); l++) mult(m,l) = 0;

    for(int j=0; j<(data.cols()+1); j++){
      for(int k=0; k<data.cols(); k++)
      {
        mult(m,j) += data(m,k)*V(j,k);
      }
      trans(m,j) = exp(mult(m,j));
      rowtot += trans(m,j);
    }
    trans.row(m) = trans.row(m)/rowtot;
  }
  return(trans);
}

template<class Type>
vector<Type> modzeros(vector<Type> data, double delta)
{
  Type nozero;
  vector<Type> dnozero(data.size());

  //  for(int j=0; j<data.rows(); j++){
  nozero = 0.0;
  for(int k=0; k<data.size(); k++){
    if(data(k)==0.0) nozero += 1.0;
  }

  for(int i=0; i<data.size(); i++){
    if(data(i)==0.0) dnozero(i) = delta;
    else dnozero(i) = (1 - nozero*delta)*data(i);
  }
  return(dnozero);
}

template<class Type>
matrix<Type> modzerosmat(matrix<Type> data, double delta)
{
  Type nozero;
  matrix<Type> dnozero(data.rows(), data.cols());

  for(int j=0; j<data.rows(); j++){
    nozero = 0.0;
    for(int k=0; k<data.cols(); k++){
      if(data(j,k)==0.0) nozero += 1.0;
    }

    for(int i=0; i<data.cols(); i++){
      if(data(j,i)==0.0) dnozero(j,i) = delta;
      else dnozero(j,i) = (1 - nozero*delta)*data(j,i);
    }
  }
  return(dnozero);
}

template<class Type>
matrix<Type> ilrm(matrix<Type> data, matrix<Type> V)
{
  matrix<Type> trans(data.rows(), data.cols());
  matrix<Type> mult(data.rows(),data.cols()-1);

  Type gmean;
  Type product;

  // going over each row to individually transform rows
  for(int m=0; m<data.rows(); m++){
    product = 1.0;
    for(int i = 0; i < data.cols(); i++) product *= data(m,i);
    gmean = exp(log(product)/data.cols());

    for(int l=0; l<trans.cols(); l++) trans(m,l) = log(data(m,l)/gmean);

    for(int j=0; j<(trans.cols()-1); j++){
      mult(m,j) = 0.0;
      for(int k=0; k<trans.cols(); k++)
      {
        mult(m,j) += trans(m,k)*V(k,j);
      }
    }
  }
  return(mult);
}

template<class Type>
vector<Type> ilrc(vector<Type> data, matrix<Type> V)
{
  vector<Type> trans(data.size());
  vector<Type> mult(data.size()-1);

  // going over each row to individually transform rows
  // for(int m=0; m<data.rows(); m++){
  Type product = 1.0;
  for(int i = 0; i < data.size(); i++) product *= data(i);
  Type gmean = exp(log(product)/data.size());

  for(int l=0; l<trans.size(); l++) trans(l) = log(data(l)/gmean);

  for(int j=0; j<(trans.size()-1); j++){
    mult(j) = 0.0;
    for(int k=0; k<trans.size(); k++)
    {
      mult(j) += trans(k)*V(k,j);
    }
  }
  // }
  return(mult);
}

template<class Type>
Type objective_function<Type>::operator() () {

  // Data:
  DATA_MATRIX(y); // each row is observed ilr transformed FAs of predators
 // DATA_MATRIX(x); // observed ilr transformed prey FAs, each row represents and individual prey FA
  DATA_VECTOR(n); // number of observed prey FAs for each specific prey species in x (in same order as in x)
  DATA_MATRIX(varz); // estimated pooled variance-covariance matrix of the untransformed prey xi
  DATA_MATRIX(mu); // each row is the mean vector for species i (Note this is the mean of the ilr transformed prey FAs)
  DATA_MATRIX(V); // V matrix that is D*(D-1) to go from clr transformation to ilr transformation
  // DATA_MATRIX(G); // G matrix that is required to go from T to clr variance
  DATA_VECTOR(sind); // start values for the mean quantile of the diagonal of the covariance

  // Parameters:
  // PARAMETER(lambda); // Lagrange multiplier parameter
  PARAMETER_MATRIX(alpha); // each row is diet proportion vector for predator i, I-1 proportions
  PARAMETER_ARRAY(z); // unobserved ilr transformed prey effect, for each individual predator
  PARAMETER_VECTOR(sepsilon); // The diagonal entries of the variance-covariance matrix of the ilr transformed epsilon
  // Procedures:
  ADREPORT(alpha);
  ADREPORT(sepsilon);
  //ADREPORT(sepsilon);

  int D = y.cols(); // number of fatty acids - 1 (since ilr transformed)
  int I = n.size(); // number of species
  int npred = y.rows(); // number of predators

  Type nll = 0.0; // initialize negative loglik

  // Latent process:
  vector<Type> tmp(D); // initialize point at which to evaluate neg log-density
  // vector<Type> yomean(D+1); // initialize the mean of the predator yo
  matrix<Type> ymean; // initialize the transformed mean of the predator y

  // Rcout << ymean;
  array<Type> zarray;
  matrix<Type> zo;
  matrix<Type> zt;
  matrix<Type> eta;

  // getting the variance-covariance of z from T
  //matrix<Type> varz = V.transpose()*G;
  //varz = varz*T;
  //varz = varz*G;
  //varz = varz*V;
  //varz = -0.5*varz;
  //REPORT(varz);

  MVNORM_t<Type> nll_dist(varz); // declare multivariate normal with cov mat for prey

  // creating a diagonal matrix
  matrix<Type> Sigmay(D,D);
  Sigmay.fill(0);
  for(int k = 0; k < D; k++){
    for(int l=0; l < 4; l++){
      if(sind(k)==(l+1)) Sigmay(k,k) = sepsilon(l);
    }
  }

  // matrix<Type> Sigmay = sepsilon*Id;
  REPORT(Sigmay);
  MVNORM_t<Type> nll_y(Sigmay); // declare multivariate normal with cov mat for y
  //
  //

  matrix<Type> alphafull(npred,I);
  for(int r=0; r<npred; r++){
    vector<Type> vr = alpha.row(r);
    for(int c=0; c<I; c++){
      if(c<I-1) alphafull(r,c) = alpha(r,c);
      else alphafull(r,c) = 1 - sum(vr);
    }
  }

  for(int w=0; w<npred; w++){
    zarray = z.col(w);
    zt = zarray.matrix();
    //int size = z.cols();
     //REPORT(size);
    zo = invilrc(zt,V);
    //REPORT(zo);
    //
    //eta = Multiply(alpha.row(w),zo);
    eta = alphafull.row(w)*zo;
    REPORT(eta);

    eta = modzerosmat(eta, 0.00005);
    ymean = ilrm(eta,V);
    REPORT(ymean);

    //   // Observation models:
    tmp = y.row(w) - ymean; // centers it
    nll += nll_y(tmp);

    //  adding in the likelihood of z, the random effect
    for(int i = 0; i < I; i++){ //
      tmp =  zt.row(i) - mu.row(i); // centers it
      nll += nll_dist(tmp);
    }
  }




  //
  //REPORT(nll);
  return nll;
}
